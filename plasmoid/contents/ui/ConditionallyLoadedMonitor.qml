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

Item {
    property var values
    property var orig_values

    Layout.fillWidth: true
    Layout.fillHeight: true

    function source_url() {
        switch (plasmoid.configuration.monitor_type) {
            default:
            case 0:
                return "CircularMonitor.qml";
            case 1:
                return "BarMonitor.qml";
            case 2:
                return "PlotterMonitor.qml";
            case 3:
                return "NumberMonitor.qml";
        }
    }

    Loader {
        id: loader
        active: visible
        anchors.fill: parent
        source: source_url()
        onLoaded: {
            loader.item.values = Qt.binding(function() { return values })
            loader.item.orig_values = Qt.binding(function() { return orig_values })
        }
    }

    Connections {
        target: plasmoid.configuration
        onColorsChanged: loader.setSource(source_url(), {})
    }
}

