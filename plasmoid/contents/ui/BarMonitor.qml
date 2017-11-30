/*
 * Copyright (C) 2014 Martin Yrjölä <martin.yrjola@gmail.com>
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

import QtQuick 2.2
import QtQuick.Layouts 1.1
import org.kde.plasma.components 2.0 as PlasmaComponents

import "../code/utils.js" as Utils

Item {
    id: bar_monitor

    anchors.fill: parent
    height: childrenRect.height

    property var orig_values
    property var values

    ColumnLayout {
        width: parent.width

        Item {
            id: bar_row

            height: Utils.get_height(plasmoid.configuration, bar_monitor)

            Rectangle {
                id: bar_border

                height: Utils.get_height(plasmoid.configuration, bar_monitor)
                width: bar_monitor.width

                color: "transparent"

                radius: 3
                opacity: .4

                border {
                    color: theme.textColor
                    width: 1
                }
            }

            Repeater {
                id: bar_repeater
                model: values.length

                Rectangle {
                    color: plasmoid.configuration.colors[index]
                    height: (bar_border.height - (bar_border.border.width * 2)) * bar_monitor.values[index]
                    width: bar_border.width - (bar_border.border.width * 2)
                    z: -1
                    anchors {
                        bottom: index == 0
                            ? bar_border.bottom
                            : bar_repeater.itemAt(index - 1).top
                        bottomMargin: index == 0
                            ? bar_border.border.width
                            : 0
                    }
                }
            }
        }

        PlasmaComponents.Label {
            id: bar_label

            width: bar_border.width
            Layout.maximumWidth: bar_border.width
            visible: Utils.is_label_visible(plasmoid.configuration)
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter

            onVisibleChanged: {
                bar_row.height = Utils.get_height(plasmoid.configuration, bar_monitor)
                bar_monitor.height = Utils.get_height(plasmoid.configuration, bar_monitor)
            }

            anchors {
                top: bar_row.bottom
                horizontalCenter: parent.horizontalCenter
            }

            text: Utils.get_label(plasmoid.configuration, orig_values)
        }
    }
}

