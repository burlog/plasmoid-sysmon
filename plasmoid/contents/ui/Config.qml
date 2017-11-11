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
    id: config

    property alias cfg_label: label_text_field.text
    property alias cfg_update_interval: update_interval_spinbox.value
    property alias cfg_max_value: max_value_spinbox.value
    property string cfg_default_color

    GridLayout {
        id: layout

        columns: 2
        columnSpacing: 10
        rowSpacing: 10

        QtControls.Label {
            text: i18n("Label:")
            Layout.alignment: Qt.AlignRight
        }

        QtControls.TextField {
            id: label_text_field
            font.capitalization: Font.SmallCaps
        }

        QtControls.Label {
            text: i18n("Default Color")
            Layout.alignment: Qt.AlignRight
        }

        ColorPicker {
            id: default_color_picker
            chosen_color: plasmoid.configuration.default_color
            onColorSelected: {
                cfg_default_color = chosen_color.toString()
            }
        }

        QtControls.Label {
            text: i18n("Forced Maximum Value:")
            Layout.alignment: Qt.AlignRight
        }

        QtControls.SpinBox {
            id: max_value_spinbox
            minimumValue: 0.0
            maximumValue: Number.MAX_VALUE
            stepSize: 1.0
        }

        QtControls.Label {
            text: i18n("Update interval:")
            Layout.alignment: Qt.AlignRight
        }

        QtControls.SpinBox {
            id: update_interval_spinbox
            suffix: i18nc("Abbreviation for seconds", "s")
            decimals: 1
            minimumValue: 0.1
            maximumValue: Number.MAX_VALUE
            stepSize: 0.1
        }
    }
}

