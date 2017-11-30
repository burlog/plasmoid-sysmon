/*
 * Copyright (C) 2017 Michal Bukovský <burlog@seznam.cz>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.2 as QtControls

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: config

    signal configurationChanged(var model)

    property var cfg_names: []
    property var cfg_colors: []
    property alias cfg_last_filter: filter.text

    onConfigurationChanged: {
        cfg_colors.length = cfg_names.length
        var sys_name = "sys." + model.name
        if (model.checked) {
            var i = cfg_names.indexOf(sys_name)
            if (i == -1) {
                cfg_names.push(sys_name)
                cfg_colors.push(model.color)
            } else cfg_colors[i] = model.color
        } else {
            var i = cfg_names.indexOf(sys_name)
            if (i != -1) {
                cfg_names.splice(i, 1)
                cfg_colors.splice(i, 1)
            }
        }
    }

    PlasmaCore.DataSource {
        id: systemmonitor
        engine: "systemmonitor"
    }

    Component.onCompleted: {
        cfg_names = plasmoid.configuration.names.slice()
        cfg_colors = plasmoid.configuration.colors.slice()
        var tmp_last_filter = cfg_last_filter
        cfg_last_filter = ""

        for (var i in systemmonitor.sources) {
            var name = systemmonitor.sources[i]
            if (name.match(/[^\x{0000}-\x{007F}]/)) continue
            var j = cfg_names.indexOf("sys." + name)
            if (j == -1) {
                sysmon_sources_model.append({
                    "name": name,
                    "color": plasmoid.configuration.default_color,
                    "checked": false
                });
            } else {
                sysmon_sources_model.append({
                    "name": name,
                    "color": cfg_colors[j],
                    "checked": true
                });
            }
        }

        cfg_last_filter = tmp_last_filter
    }

    // this is just for getting the column width
    QtControls.CheckBox {
        id: hidden_checkbox
        visible: false
    }

    ColumnLayout {
        anchors.fill: parent

        QtControls.TextField {
            id: filter
            Layout.fillWidth: true
            placeholderText: i18n("Search SysMon sources")

            onTextChanged: {
                sysmon_sources_proxy_model.filterString = text
            }
        }

        QtControls.TableView {
            id: sysmon_sources_view

            selectionMode: QtControls.SelectionMode.NoSelection

            Layout.fillWidth: true
            Layout.fillHeight: true

            model: PlasmaCore.SortFilterModel {
                id: sysmon_sources_proxy_model

                filterRole: "name"
                sortRole: "name"
                sortOrder: "AscendingOrder"

                sourceModel: ListModel {
                    id: sysmon_sources_model
                }
            }

            rowDelegate: Rectangle {
                height: hidden_checkbox.height + 8
                SystemPalette {
                    id: row_pallete;
                    colorGroup: SystemPalette.Active
                }
                color: {
                    var base_color = styleData.alternate
                         ? row_pallete.base
                         : row_pallete.alternateBase
                    return styleData.selected
                         ? row_pallete.highlight
                         : base_color
                }
            }

            // the first column with checkbox
            QtControls.TableViewColumn {
                id: selected_col
                role: "selected"

                title: i18n("Show")
                width: hidden_checkbox.width + 32

                delegate: RowLayout {
                    RowLayout {
                        anchors.horizontalCenter: parent.horizontalCenter

                        QtControls.CheckBox {
                            id: source_selected
                            anchors.left: parent.left
                            activeFocusOnTab: false

                            checked: model
                                ? model.checked
                                : false

                            onClicked: {
                                if (model) model.checked = checked
                                configurationChanged(model)
                            }
                        }
                        ColorPicker {
                            id: color_selected
                            anchors.left: source_selected.right
                            activeFocusOnTab: false

                            enabled: model
                                ? model.checked
                                : false
                            chosen_color: model
                                ? model.color
                                : plasmoid.configuration.default_color

                            onColorSelected: {
                                if (model) model.color = chosen_color.toString()
                                configurationChanged(model)
                            }
                        }
                    }
                }
            }

            // the second column with source name
            QtControls.TableViewColumn {
                id: name_col

                role: "name"
                title: i18n("Source Name")

                // rest of table
                width: sysmon_sources_view.width - selected_col.width - 32

                delegate: PlasmaComponents.Label {
                    text: model.name

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if (model) model.checked = !model.checked
                            configurationChanged(model)
                        }
                    }
                }
            }
        }
    }
}

