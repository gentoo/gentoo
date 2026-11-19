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
# env:       Mandatory, must correspond with registered values for Desktop
#            Environments. Passed to OnlyShowIn value, and used to make a
#            desktop file: 'polkit-${env,,}-authentication-agent.desktop'
# pkagent:   Target (known) polkit-agent package to choose from for Exec
#            If unknown, directly pick value for Exec path
# @CODE
#
# Example usage:
# @CODE
#   XFCE polkit-gnome
# @CODE
make_pkagent_autostart_entry() {
	local env execpath fname
	if [[ $# -ne 2 ]]; then
		die "${FUNCNAME[0]} must be passed exactly two arguments"
	fi

	# List of registered OnlyShowIn values for validation. Source:
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
		Old) ;;
		*)
			ewarn "${1} is not a registered OnlyShowIn value in the Desktop Application Autostart Specification."
			;;
	esac
	env="${1}"

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

	# preserve existing filename for a de facto legacy standard in GTK world
	if [[ ${PN} == polkit-gnome ]]; then
		fname="polkit-gnome-authentication-agent-1.desktop"
	else
		fname="polkit-${env,,}-authentication-agent.desktop"
	fi

	cat > "${T}/${fname}" <<- _EOF_ || die
		[Desktop Entry]
		Name=PolicyKit Authentication Agent
		Comment=PolicyKit Authentication Agent
		Exec=${execpath}
		Icon=dialog-password
		Terminal=false
		Type=Application
		OnlyShowIn=${env};
		NoDisplay=true
	_EOF_

	(
		insinto /etc/xdg/autostart
		doins "${T}/${fname}"
	)
}

fi
