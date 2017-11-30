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

import "../code/utils.js" as Utils

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

    // the data arrays
    property var values: []
    property var orig_values: []

    // execute source
    PlasmaCore.DataSource {
        id: execute_ds
        engine: "executable"

        property var tick

        // what data is requested from the systemmonitor data source
        connectedSources: {
            var sources = []
            for (var i = 0; i < plasmoid.configuration.names.length; ++i) {
                var exe_name = plasmoid.configuration.names[i]
                if (exe_name.substring(0, 4) == "exe.")
                    sources.push(exe_name.substring(4))
            }
            return sources
        }

        // flush all values
        onConnectedSourcesChanged: {
            values = []
            orig_values = []
            plasmoid.configuration.guessed_max_value = 0.0
        }

        // called when new data is available
        onNewData: {
            var exe_source_name = "exe." + sourceName
            for (var i = 0; i < plasmoid.configuration.names.length; ++i) {
                if (plasmoid.configuration.names[i] == exe_source_name) {
                    while (i >= orig_values.length) orig_values.push(0)
                    orig_values[i] = Number(data.stdout)
                    while (i >= values.length) values.push(0)
                    values[i] = normalize(orig_values, data.stdout, i)
                }
            }
            var current_tick = Math.floor(Date.now() / 1000)
            if (tick != current_tick) {
                valuesChanged()
                orig_valuesChanged()
                tick = current_tick
            }
        }

        // the update interval
        interval: plasmoid.configuration.update_interval * 1000
    }

    // the source of data about cpu
    PlasmaCore.DataSource {
        id: systemmonitor
        engine: "systemmonitor"

        property var tick

        // what data is requested from the systemmonitor data source
        connectedSources: {
            var sources = []
            for (var i = 0; i < plasmoid.configuration.names.length; ++i) {
                var sys_name = plasmoid.configuration.names[i]
                if (sys_name.substring(0, 4) == "sys.")
                    sources.push(sys_name.substring(4))
            }
            return sources
        }

        // flush all values
        onConnectedSourcesChanged: {
            values = []
            orig_values = []
            plasmoid.configuration.guessed_max_value = 0.0
        }

        // called when new data is available
        onNewData: {
            var sys_source_name = "sys." + sourceName
            for (var i = 0; i < plasmoid.configuration.names.length; ++i) {
                if (plasmoid.configuration.names[i] == sys_source_name) {
                    while (i >= orig_values.length) orig_values.push(0)
                    orig_values[i] = Number(data.value)
                    while (i >= values.length) values.push(0)
                    values[i] = normalize(orig_values, data.value, i)
                }
            }
            var current_tick = Math.floor(Date.now() / 1000)
            if (tick != current_tick) {
                valuesChanged()
                orig_valuesChanged()
                tick = current_tick
            }
        }

        // the update interval
        interval: plasmoid.configuration.update_interval * 1000
    }

    function sum(values) {
        var values_sum = 0
        for (var i = 0; i < values.length; ++i) {
            values_sum += values[i]
        }
        return values_sum
    }

    function normalize(orig_values, value, i) {
        var max_value = plasmoid.configuration.max_value
        if (max_value == 0.0) {
            var values_sum = sum(orig_values)
            if (values_sum > Number(plasmoid.configuration.guessed_max_value))
                plasmoid.configuration.guessed_max_value = values_sum
            max_value = plasmoid.configuration.guessed_max_value * 1.2
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
                    target: main
                    onOrig_valuesChanged: {
                        if (tooltip_main_item.visible) {
                            var result = ""
                            for (var i = 0; i < plasmoid.configuration.names.length; ++i) {
                                if (i) result += "\n"
                                var value = Utils.format_number(plasmoid.configuration, main.orig_values[i])
                                var name = plasmoid.configuration.labels[i]
                                if (!name.length) name = plasmoid.configuration.names[i].substring(4)
                                result += i18n("%1: %2", name, value)
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

        // tells the monitor to fill whole parent space
        anchors {
            fill: main
        }

        ConditionallyLoadedMonitor {
            // map the values to monitor values
            values: main.values
            // map the original values to monitor values
            orig_values: main.orig_values
        }
    }
}

