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
    id: number_monitor

    anchors.fill: parent

    property var orig_values: []
    property var values: []

    ColumnLayout {
        width: number_monitor.width

        Item {
            id: number_item
            height: Utils.get_height(plasmoid.configuration, number_monitor)
            Layout.preferredWidth: number_monitor.width

            Grid {
                id: number_grid

                columns: Math.ceil(Math.sqrt(values.length))
                height: Utils.get_height(plasmoid.configuration, number_monitor)
                width: number_monitor.width
                horizontalItemAlignment: Grid.AlignHCenter
                verticalItemAlignment: Grid.AlignVCenter

                Repeater {
                    id: number_repeater
                    model: orig_values.length

                    Text {
                        height: Math.abs(number_item.height / Math.max(number_grid.children.length / number_grid.columns, 1))
                        width: Math.abs(number_item.width / Math.max(number_grid.columns, 1))
                        elide: Text.ElideRight
                        color: plasmoid.configuration.colors[index]
                        text: Utils.format_number(plasmoid.configuration, orig_values[index])
                    }
                }
            }
        }

        PlasmaComponents.Label {
            id: number_label

            width: number_monitor.width
            Layout.maximumWidth: number_monitor.width
            visible: Utils.is_label_visible(plasmoid.configuration)
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter

            onVisibleChanged: {
                number_item.height = Utils.get_height(plasmoid.configuration, number_monitor)
            }

            anchors {
                top: number_item.bottom
                horizontalCenter: parent.horizontalCenter
            }

            text: Utils.get_label(plasmoid.configuration, orig_values)
        }
    }
}

