# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: pkagent-autostart.eclass
# @MAINTAINER:
# freedesktop-bugs@gentoo.org
# @SUPPORTED_EAPIS: 8 9
# @BLURB: Installs aptly configured autostart desktop file for the chosen
# environment. May be used by environments that do not come with their own
# polkit-agent, thus reuse one of the known implementations.

case ${EAPI} in
	8|9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_PKAGENT_AUTOSTART_ECLASS} ]]; then
_PKAGENT_AUTOSTART_ECLASS=1

# @FUNCTION: make_pkagent_autostart_entry
# @USAGE: <env> <pkagent>
# @DESCRIPTION:
# Make a .desktop file and install it in /etc/xdg/autostart.
#
# @CODE
# env:       If set, must correspond with registered values for Desktop
#            Environments. Passed to OnlyShowIn value, and used to make a
#            desktop file: 'polkit-${env,,}-authentication-agent.desktop'
#            If empty, will set Hidden=true instead of OnlyShowIn.
# pkagent:   Target (known) polkit-agent package to choose from for Exec
#            If unknown, directly pick value for Exec path
# @CODE
#
# Example usage:
# @CODE
#   XFCE polkit-gnome
# @CODE
make_pkagent_autostart_entry() {
	local execpath name onlyshowin
	if [[ $# -ne 2 ]]; then
		die "${FUNCNAME[0]} must be passed exactly two arguments"
	fi

	# List of registered OnlyShowIn values for validation. Non-registered
	# environments shall be prefixed by the string "X-". Source:
	# https://specifications.freedesktop.org/menu/latest/onlyshowin-registry.html
	case ${1} in
		COSMIC | \
		GNOME | \
		GNOME-Classic | \
		GNOME-Flashback | \
		KDE | \
		LXDE | \
		LXQt | \
		MATE | \
		Razor | \
		ROX | \
		TDE | \
		Unity | \
		XFCE | \
		EDE | \
		Cinnamon | \
		Pantheon | \
		Phosh | \
		DDE | \
		Endless | \
		Old | \
		X-*)
			onlyshowin="OnlyShowIn=${1};"
			name="${PN/#X-/}"
			;;
		"")
			onlyshowin="Hidden=true"
			name="${PN/#polkit/}"
			name="${name/--/-}"
			;;
		*)
			eerror "${1} is not a registered OnlyShowIn value in the Desktop Application"
			eerror "Autostart Specification."
			die
			;;
	esac

	case ${2} in
		polkit-gnome)
			execpath="/usr/libexec/polkit-gnome-authentication-agent-1" ;;
		polkit-kde-agent)
			execpath="/usr/libexec/polkit-kde-authentication-agent-1" ;;
		mate-polkit)
			execpath="/usr/libexec/polkit-mate-authentication-agent-1" ;;
		lxsession)
			execpath="/usr/bin/lxpolkit" ;;
		lxqt-policykit)
			execpath="/usr/bin/lxqt-policykit-agent" ;;
		*)
			execpath="${2}" ;;
	esac

	local fname="polkit-${name,,}-authentication-agent.desktop"
	cat > "${T}/${fname}" <<- _EOF_ || die
		[Desktop Entry]
		Name=PolicyKit Authentication Agent
		Comment=PolicyKit Authentication Agent
		Exec=${execpath}
		Icon=dialog-password
		Terminal=false
		Type=Application
		${onlyshowin}
		NoDisplay=true
	_EOF_

	(
		insinto /etc/xdg/autostart
		doins "${T}/${fname}"
	)
}

fi
