#!/bin/bash

# tray.sh: Start the UniOS-Update systray applet
# https://github.com/Antiz96/arch-update
# SPDX-License-Identifier: GPL-3.0-or-later

if [ "${2}" == "--enable" ]; then
	# Remove the legacy autostart .desktop file (replaced by the systemd user unit)
	rm -f "${XDG_CONFIG_HOME:-${HOME}/.config}/autostart/${name}-tray.desktop"

	# shellcheck disable=SC2154
	if systemctl --user enable --now "${name}-tray.service"; then
		info_msg "$(eval_gettext "The \${_name} systray applet has been enabled, it will be automatically started and kept running for the whole session")"
		exit 0
	else
		error_msg "$(eval_gettext "Failed to enable the \${_name} systray applet")"
		exit 10
	fi
fi

# shellcheck disable=SC2154
if [ -n "${UNIOS_UPDATE_TRAY_BIN}" ]; then
        tray_bin="${UNIOS_UPDATE_TRAY_BIN}"
elif [ -f "${HOME}/.local/lib/${name}/${name}-tray" ]; then
        tray_bin="${HOME}/.local/lib/${name}/${name}-tray"
elif [ -f "/usr/local/lib/${name}/${name}-tray" ]; then
        tray_bin="/usr/local/lib/${name}/${name}-tray"
elif [ -f "/usr/lib/${name}/${name}-tray" ]; then
        tray_bin="/usr/lib/${name}/${name}-tray"
else
        echo -e >&2 "ERROR: Systray applet binary not found"
        exit 3
fi

# shellcheck disable=SC2154
if [ ! -f "${statedir}/tray_icon" ]; then
	icon_up-to-date
fi

# shellcheck disable=SC2154
touch "${statedir}"/last_updates_check{,_time,_packages,_aur,_flatpak}

# shellcheck disable=SC2154
exec {fd_tray}>"${tmpdir}/tray.lock"

if ! flock -n "${fd_tray}"; then
	error_msg "$(eval_gettext "There's already a running instance of the \${_name} systray applet")"
	exit 3
fi

info_msg "$(eval_gettext "Starting the \${_name} systray applet")"

# shellcheck disable=SC2154
export UNIOS_UPDATE_TRAY_UPDATES_PER_PAGE="${tray_updates_per_page}"
# shellcheck disable=SC2154
export UNIOS_UPDATE_SHOW_TRAY_WHEN_RELEVANT="${show_tray_when_relevant}"

# When started by the unios-update-tray systemd user unit, run in the foreground so systemd can supervise (and restart) the applet
if [ -n "${UNIOS_UPDATE_TRAY_FOREGROUND}" ]; then
	exec "${tray_bin}"
else
	setsid "${tray_bin}" &
fi
