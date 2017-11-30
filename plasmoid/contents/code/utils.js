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

function to_string(value) {
    return Number(value).toLocaleString(Qt.locale(), "f")
}

function format_number(conf, value) {
    var value_units = [
        {"unit": "Y", "exp": Math.pow(10, 24)},
        {"unit": "Z", "exp": Math.pow(10, 21)},
        {"unit": "E", "exp": Math.pow(10, 18)},
        {"unit": "P", "exp": Math.pow(10, 15)},
        {"unit": "T", "exp": Math.pow(10, 12)},
        {"unit": "G", "exp": Math.pow(10, 9)},
        {"unit": "M", "exp": Math.pow(10, 6)},
        {"unit": "k", "exp": Math.pow(10, 3)},
        {"unit": "", "exp": Math.pow(10, 0)},
        {"unit": "m", "exp": Math.pow(10, -3)},
        {"unit": "u", "exp": Math.pow(10, -6)},
        {"unit": "n", "exp": Math.pow(10, -9)},
        {"unit": "p", "exp": Math.pow(10, -12)},
        {"unit": "f", "exp": Math.pow(10, -15)},
        {"unit": "a", "exp": Math.pow(10, -18)},
    ]

    for (var i = 0; i < value_units.length; ++i) {
        var value_unit = value_units[i]
        var fixed_value = value * conf.multiplier
        if (fixed_value > value_unit.exp)
            return to_string(fixed_value / value_unit.exp) + value_unit.unit
    }
    return "0"
}

function get_label(conf, orig_values) {
    if (!conf.use_value_as_label)
        return conf.label
    var label = 0.0
    for (var i = 0; i < orig_values.length; ++i)
        label += orig_values[i]
    return format_number(conf, label)
}

function is_label_visible(conf) {
    return conf.use_value_as_label
        || (conf.label && conf.label.length)
}

function get_height(conf, base) {
    return base.height - theme.mSize(theme.defaultFont).height * (is_label_visible(conf)? 1: 0)
}

