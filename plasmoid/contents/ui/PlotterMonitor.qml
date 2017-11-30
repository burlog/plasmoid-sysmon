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
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kquickcontrolsaddons 2.0 as KQuickAddons

import "../code/utils.js" as Utils

Item {
    id: plotter_monitor

    property var orig_values
    property var values

    onValuesChanged: {
        if (plotter.dataSets.length != values.length)
            plotter.dataSets = make_data_set()
        plotter.addSample(values);
    }

    function make_data_set() {
        var plot_data = []
        for (var i = 0; i < plasmoid.configuration.colors.length; ++i) {
            var data = Qt.createQmlObject("import org.kde.kquickcontrolsaddons 2.0; PlotData {}", plotter, "plot_data_" + i)
            data.color = plasmoid.configuration.colors[i]
            plot_data.push(data)
        }
        return plot_data
    }

    KQuickAddons.Plotter {
        id: plotter

        height: Utils.get_height(plasmoid.configuration, plotter_monitor)
        width: parent.width

        horizontalGridLineCount: 0

        autoRange: true

        dataSets: make_data_set()
    }

    // the label if requested
    PlasmaComponents.Label {
        id: label

        width: plotter.width
        visible: Utils.is_label_visible(plasmoid.configuration)
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter

        onVisibleChanged: {
            plotter.height = Utils.get_height(plasmoid.configuration, plotter_monitor)
        }

        anchors {
            top: plotter.bottom
            horizontalCenter: parent.horizontalCenter
        }

        text: Utils.get_label(plasmoid.configuration, orig_values)
    }
}

