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
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: main

    // don't show icon in panel
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    // be sure that KSysguard is running
    PlasmaCore.DataSource {
        id: apps
        engine: "apps"

        connectedSources: ["org.kde.ksysguard.desktop"]
    }

    // the source of data about cpu
    PlasmaCore.DataSource {
        id: systemmonitor
        engine: "systemmonitor"

        // the data arrays
        property var values: []
        property var orig_values: []
        property var colors: []

        // what data is requested from the systemmonitor data source
        connectedSources: plasmoid.configuration.names

        // called when new data is available
        onNewData: {
            for (var i = 0; i < plasmoid.configuration.names.length; ++i) {
                if (plasmoid.configuration.names[i] == sourceName) {
                    while (i >= values.length) values.push(0)
                    values[i] = normalize(data.value, i)
                    while (i >= orig_values.length) orig_values.push(0)
                    orig_values[i] = Number(data.value)
                    while (i >= colors.length) colors.push(plasmoid.configuration.default_color)
                    colors[i] = plasmoid.configuration.colors[i]
                }
            }
            valuesChanged()
            orig_valuesChanged()
        }

        // the update interval
        interval: plasmoid.configuration.update_interval * 1000
    }

    function normalize(value, i) {
        var max_value = plasmoid.configuration.max_value
        if (max_value == 0.0) {
            if (value > Number(plasmoid.configuration.guessed_max_values[i])) {
                var new_guessed_max_values = plasmoid.configuration.guessed_max_values.slice()
                new_guessed_max_values[i] = String(value)
                plasmoid.configuration.guessed_max_values = new_guessed_max_values
            }
            for (var j = 0; j < plasmoid.configuration.guessed_max_values.length; ++j)
                max_value += Number(plasmoid.configuration.guessed_max_values[j])
            max_value *= 1.01
        }
        value = value / max_value
        return isNaN(value)? 0: Math.min(value, 1)
    }

    PlasmaCore.ToolTipArea {
        id: tooltip
        anchors.fill: parent
        active: true

        mainItem: ColumnLayout {
            id: tooltip_main_item

            visible: false
            anchors.leftMargin: 10

            PlasmaExtras.Heading {
                id: tooltip_heading
                level: 3
                text: i18n("SysMon")
            }

            PlasmaComponents.Label {
                id: tooltip_text
                font.weight: Font.Normal
                text: ""

                Connections {
                    target: systemmonitor
                    onOrig_valuesChanged: {
                        if (tooltip_main_item.visible) {
                            var result = ""
                            for (var i = 0; i < plasmoid.configuration.names.length; ++i) {
                                if (i) result += "\n"
                                result += i18n("%1: %2", plasmoid.configuration.names[i], Math.round(systemmonitor.orig_values[i]))
                            }
                            tooltip_text.text = result
                        }
                    }
                }
            }
        }
    }

    // the widget
    ColumnLayout {
        id: view

        // tells the CircularMonitor to fill whole parent space
        anchors {
            fill: main
        }

        CircularMonitor {
            // hopefuly adjust label to center of circles
            anchors {
                topMargin: 5
            }

            // use configured colors
            colors: systemmonitor.colors
            // map the values to CircularMonitor values
            values: systemmonitor.values
        }

        // the label if requested
        PlasmaComponents.Label {
            id: label

            // use small caps for label
            font.capitalization: Font.SmallCaps

            // tells the label to be centered in parent (in the centre of CircularMonitor)
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            // the value
            text: plasmoid.configuration.label
        }
    }
}

