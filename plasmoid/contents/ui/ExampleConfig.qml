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

import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.2 as QtControls

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: examples

    property var configs: [
        {
            "description": "CPU circular monitor",
            "config": {
                "label": "cpu",
                "monitor_type": 0,
                "names": ["sys.cpu/system/user", "sys.cpu/system/sys", "sys.cpu/system/nice", "sys.cpu/system/wait"],
                "labels": ["", "", "", ""],
                "colors": ["limegreen", "royalblue", "chocolate", "crimson"],
                "max_value": 100,
                "last_filter": "cpu/system",
            }
        }, {
            "description": "Memory bar monitor, set the amount of memory of your computer to max_value field in kilobytes",
            "config": {
                "label": "mem",
                "monitor_type": 1,
                "names": ["sys.mem/physical/application", "sys.mem/physical/buf", "sys.mem/physical/cached"],
                "labels": ["", "", ""],
                "colors": ["limegreen", "royalblue", "chocolate"],
                "max_value": 16330816,
                "multiplier": 1000,
                "last_filter": "mem/physical",
            }
        }, {
            "description": "Processor temperature monitor for SkyLake chipset",
            "config": {
                "label": "temp",
                "monitor_type": 0,
                "names": ["sys.acpi/Thermal_Zone/6-pch_skylake/Temperature"],
                "labels": [""],
                "colors": ["limegreen"],
                "max_value": 100,
                "last_filter": "acpi/Thermal_Zone",
            }
        }, {
            "description": "Battery charge monitor",
            "config": {
                "label": "bat",
                "monitor_type": 0,
                "names": ["sys.acpi/battery/0/batterycharge"],
                "labels": [""],
                "colors": ["limegreen"],
                "max_value": 100,
                "last_filter": "acpi/battery",
            }
        }, {
            "description": "Loopback network interface traffic plotting monitor, change to you network interface",
            "config": {
                "label": "lo",
                "monitor_type": 2,
                "names": ["sys.network/interfaces/lo/receiver/data", "sys.network/interfaces/lo/transmitter/data"],
                "labels": ["", ""],
                "colors": ["limegreen", "royalblue"],
                "last_filter": "network/interfaces",
            }
        }, {
            "description": "System load plotting monitor",
            "config": {
                "label": "load",
                "monitor_type": 2,
                "names": ["sys.cpu/system/TotalLoad"],
                "labels": [""],
                "colors": ["limegreen"],
                "last_filter": "cpu/system",
            }
        }, {
            "description": "Ping time to 8.8.8.8",
            "config": {
                "label": "ping",
                "monitor_type": 2,
                "multiplier": 0.001,
                "names": ["exe.ping -nqc 1 8.8.8.8 -W 1 | cut -s -f 5 -d/"],
                "labels": ["ping 8.8.8.8"],
                "colors": ["limegreen"],
                "update_interval": 2
            }
        }
    ]

    Column {
        anchors.fill: parent
        spacing: 20

        Text {
            id: description_label
            width: parent.width
            color: theme.textColor
            textFormat: Text.StyledText
            wrapMode: Text.WordWrap
            text: "Here are some examples that show you how to configure SysMon and what can be done with it.  "
                  + "Just click on any item bellow and you will see the result immediately.  After that go to "
                  + "other configuration and data sources tabs to see how it is done."
        }

        ListView {
            id: view
            height: parent.height - description_label.height
            width: parent.width
            model: configs
            spacing: 10

            delegate: Rectangle {
                width: parent.width
                height: Math.round(theme.mSize(theme.defaultFont).height * 1.6)
                color: theme.backgroundColor
                border {
                    color: Qt.lighter(theme.backgroundColor)
                    width: 1
                }

                Text {
                    id: text_view
                    width: parent.width
                    color: theme.textColor
                    text: modelData.description
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 10
                    }

                    Behavior on color {
                        SequentialAnimation {
                            loops: 3
                            ColorAnimation {
                                from: theme.textColor
                                to: theme.highlightColor
                                duration: 300
                            }
                            ColorAnimation {
                                from: theme.highlightColor
                                to: theme.textColor
                                duration: 300
                            }
                        }
                    }
                }

                MouseArea {
                    id: mousearea
                    anchors.fill: parent
                    property Text text
                    onClicked: {
                        text.color = theme.highlightColor
                        for (var name in modelData.config)
                            plasmoid.configuration[name] = modelData.config[name]
                    }
                }

                Component.onCompleted: {
                    mousearea.text = text_view
                }
            }
        }
    }
}

