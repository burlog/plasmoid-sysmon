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

import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.components 2.0 as PlasmaComponents

import "../code/utils.js" as Utils

Item {
    id: circular_monitor

    property var orig_values
    property alias values: canvas.values

    anchors {
        fill: parent
    }

    onValuesChanged: {
        for (var i = 0; i < values.length; i++)
            if (values[i] > 1.0)
                return
        canvas.requestPaint()
    }

    Canvas {
        id: canvas

        property int lineWidth: 1
        property bool fill: true
        property bool stroke: true
        property real alpha: 1.0

        property var values

        // This fixes edge bleeding
        readonly property double filler: 0.01

        width: parent.width
        height: parent.height
        antialiasing: true

        onPaint: {
            var ctx = getContext("2d")
            ctx.save()
            ctx.clearRect(0, 0, canvas.width, canvas.height)
            ctx.strokeStyle = canvas.strokeStyle
            ctx.globalAlpha = canvas.alpha

            // start from 6 o'clock
            var currentRadian = Math.PI / 2
            var min = Math.min(height, width)

            // draw the sectors
            for (var i = 0; i < values.length; i++) {
                var radians = values[i] * 2 * Math.PI
                ctx.fillStyle = plasmoid.configuration.colors[i]
                ctx.beginPath()
                ctx.arc(width / 2, height / 2, min / 2.03, currentRadian, currentRadian + radians + filler, false)
                ctx.arc(width / 2, height / 2, min / 3.5, currentRadian + radians + filler, currentRadian, true)
                currentRadian += radians - filler
                ctx.closePath()
                ctx.fill()
            }

            // draw border
            ctx.fillStyle = "transparent"
            ctx.strokeStyle = theme.textColor
            ctx.lineWidth = canvas.lineWidth
            ctx.globalAlpha = .4
            ctx.beginPath()
            ctx.arc(width / 2, height / 2, min / 2.03, Math.PI / 2, 5 * Math.PI / 2, false)
            ctx.arc(width / 2, height / 2, min / 3.5, Math.PI / 2, 5 * Math.PI / 2, false)
            ctx.fillRule = Qt.OddEvenFill
            ctx.fill()
            ctx.stroke()
            ctx.restore()
        }
    }

    // the label if requested
    PlasmaComponents.Label {
        id: label
        width: parent.width - (Math.min(canvas.height, canvas.width) / 2.03 - Math.min(canvas.height, canvas.width) / 3.5) * 2
        horizontalAlignment: Text.AlignHCenter
        elide: Text.ElideRight

        // tells the label to be centered in parent (in the centre of CircularMonitor)
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

        // the value
        text: Utils.get_label(plasmoid.configuration, orig_values)
    }
}

