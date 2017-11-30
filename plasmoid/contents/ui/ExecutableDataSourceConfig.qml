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

    signal configurationChanged(var model, int remove)

    property var cfg_names: []
    property var cfg_colors: []
    property var cfg_labels: []

    onConfigurationChanged: {
        cfg_colors.length = cfg_names.length
        cfg_labels.length = cfg_names.length

        var exe_name = "exe." + model.command
        if (!remove) {
            var i = cfg_names.indexOf(exe_name)
            if (i == -1) {
                cfg_names.push(exe_name)
                cfg_colors.push(model.color)
                cfg_labels.push(model.label)
            } else cfg_colors[i] = model.color
        } else {
            var i = cfg_names.indexOf(exe_name)
            if (i != -1) {
                cfg_names.splice(i, 1)
                cfg_colors.splice(i, 1)
                cfg_labels.splice(i, 1)
            }
        }
    }

    Component.onCompleted: {
        cfg_names = plasmoid.configuration.names.slice()
        cfg_colors = plasmoid.configuration.colors.slice()
        cfg_labels = plasmoid.configuration.labels.slice()

        for (var i = 0; i < cfg_names.length; ++i) {
            var exe_name = plasmoid.configuration.names[i]
            if (exe_name.substring(0, 4) == "exe.") {
                exe_sources_model.append({
                    "label": cfg_labels[i],
                    "command": exe_name.substring(4),
                    "color": cfg_colors[i],
                })
            }
        }
    }

    Column {
        width: parent.width
        height: parent.height
        spacing: 10

        QtControls.TableView {
            id: exe_sources_view

            height: parent.height - grid_layout.height - 20
            width: parent.width

            selectionMode: QtControls.SelectionMode.NoSelection

            model: ListModel {
                id: exe_sources_model
            }

            rowDelegate: Rectangle {
                height: theme.mSize(theme.defaultFont).height * 1.6
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
                id: color_col
                role: "color"

                title: i18n("Show")
                width: theme.mSize(theme.defaultFont).width * 5

                delegate: Item {
                    anchors.fill: parent

                    ColorPicker {
                        id: color_picker
                        activeFocusOnTab: false
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            verticalCenter: parent.verticalCenter
                        }

                        chosen_color: model
                            ? model.color
                            : plasmoid.configuration.default_color

                        onColorSelected: {
                            if (model) model.color = chosen_color.toString()
                            configurationChanged(model, false)
                        }
                    }
                }
            }

            QtControls.TableViewColumn {
                id: label_col
                role: "label"

                title: i18n("Label")
                width: theme.mSize(theme.defaultFont).width * 10
            }

            QtControls.TableViewColumn {
                id: cmd_col
                role: "command"
                width: exe_sources_view.width - color_col.width - label_col.width - actions_col.width - 10

                title: i18n("Command")
            }

            QtControls.TableViewColumn {
                id: actions_col
                width: theme.mSize(theme.defaultFont).width * 7

                delegate: QtControls.Button {
                    text: i18n("Delete")
                    onClicked: {
                        configurationChanged(model, true)
                        exe_sources_model.remove(model.index, 1)
                    }
                }
            }
        }

        GridLayout {
            id: grid_layout

            columns: 2
            columnSpacing: 10
            rowSpacing: 10
            width: parent.width

            QtControls.Label {
                text: i18n("Label:")
                Layout.alignment: Qt.AlignRight
            }

            QtControls.TextField {
                id: label_text_field
                Layout.preferredWidth: command_text_field.placeholderText.length * theme.mSize(theme.defaultFont).width
            }

            QtControls.Label {
                text: i18n("Command:")
                Layout.alignment: Qt.AlignRight
            }

            QtControls.TextField {
                id: command_text_field
                Layout.preferredWidth: placeholderText.length * theme.mSize(theme.defaultFont).width
                placeholderText: i18n("The command should print one number to stdout")
            }

            QtControls.Button {
                text: i18n("Add")
                enabled: command_text_field.text.length
                onClicked: {
                    var model = {
                        "label": label_text_field.text,
                        "command": command_text_field.text,
                        "color": plasmoid.configuration.default_color,
                    }
                    exe_sources_model.append(model)
                    configurationChanged(model, false)
                    label_text_field.text = ""
                    command_text_field.text = ""
                }
            }
        }
    }
}

