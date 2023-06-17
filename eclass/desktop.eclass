# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: desktop.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: support for desktop files, menus, and icons

case ${EAPI} in
	6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_DESKTOP_ECLASS} ]]; then
_DESKTOP_ECLASS=1

# @FUNCTION: make_desktop_entry
# @USAGE: <command> [name] [icon] [type] [fields]
# @DESCRIPTION:
# Make a .desktop file.
#
# @CODE
# binary:   what command does the app run with ?
# name:     the name that will show up in the menu
# icon:     the icon to use in the menu entry
#           this can be relative (to /usr/share/pixmaps) or
#           a full path to an icon
# type:     what kind of application is this?
#           for categories:
#           https://specifications.freedesktop.org/menu-spec/latest/apa.html
#           if unset, function tries to guess from package's category
# fields:	extra fields to append to the desktop file; a printf string
# @CODE
make_desktop_entry() {
	[[ -z $1 ]] && die "make_desktop_entry: You must specify the executable"

	local exec=${1}
	local name=${2:-${PN}}
	local icon=${3:-${PN}}
	local type=${4}
	local fields=${5}

	if [[ -z ${type} ]] ; then
		local catmaj=${CATEGORY%%-*}
		local catmin=${CATEGORY##*-}
		case ${catmaj} in
			app)
				case ${catmin} in
					accessibility) type="Utility;Accessibility";;
					admin)         type=System;;
					antivirus)     type=System;;
					arch)          type="Utility;Archiving";;
					backup)        type="Utility;Archiving";;
					cdr)           type="AudioVideo;DiscBurning";;
					dicts)         type="Office;Dictionary";;
					doc)           type=Documentation;;
					editors)       type="Utility;TextEditor";;
					emacs)         type="Development;TextEditor";;
					emulation)     type="System;Emulator";;
					laptop)        type="Settings;HardwareSettings";;
					office)        type=Office;;
					pda)           type="Office;PDA";;
					vim)           type="Development;TextEditor";;
					xemacs)        type="Development;TextEditor";;
				esac
				;;

			dev)
				type="Development"
				;;

			games)
				case ${catmin} in
					action|fps) type=ActionGame;;
					arcade)     type=ArcadeGame;;
					board)      type=BoardGame;;
					emulation)  type=Emulator;;
					kids)       type=KidsGame;;
					puzzle)     type=LogicGame;;
					roguelike)  type=RolePlaying;;
					rpg)        type=RolePlaying;;
					simulation) type=Simulation;;
					sports)     type=SportsGame;;
					strategy)   type=StrategyGame;;
				esac
				type="Game;${type}"
				;;

			gnome)
				type="Gnome;GTK"
				;;

			kde)
				type="KDE;Qt"
				;;

			mail)
				type="Network;Email"
				;;

			media)
				case ${catmin} in
					gfx)
						type=Graphics
						;;
					*)
						case ${catmin} in
							radio) type=Tuner;;
							sound) type=Audio;;
							tv)    type=TV;;
							video) type=Video;;
						esac
						type="AudioVideo;${type}"
						;;
				esac
				;;

			net)
				case ${catmin} in
					dialup) type=Dialup;;
					ftp)    type=FileTransfer;;
					im)     type=InstantMessaging;;
					irc)    type=IRCClient;;
					mail)   type=Email;;
					news)   type=News;;
					nntp)   type=News;;
					p2p)    type=FileTransfer;;
					voip)   type=Telephony;;
				esac
				type="Network;${type}"
				;;

			sci)
				case ${catmin} in
					astro*)  type=Astronomy;;
					bio*)    type=Biology;;
					calc*)   type=Calculator;;
					chem*)   type=Chemistry;;
					elec*)   type=Electronics;;
					geo*)    type=Geology;;
					math*)   type=Math;;
					physics) type=Physics;;
					visual*) type=DataVisualization;;
				esac
				type="Education;Science;${type}"
				;;

			sys)
				type="System"
				;;

			www)
				case ${catmin} in
					client) type=WebBrowser;;
				esac
				type="Network;${type}"
				;;

			*)
				type=
				;;
		esac
	fi

	local desktop_exec="${exec%%[[:space:]]*}"
	desktop_exec="${desktop_exec##*/}"
	local desktop_suffix="-${PN}"
	[[ ${SLOT%/*} != 0 ]] && desktop_suffix+="-${SLOT%/*}"
	# Replace foo-foo.desktop by foo.desktop
	[[ ${desktop_suffix#-} == "${desktop_exec}" ]] && desktop_suffix=""

	# Prevent collisions if a file with the same name already exists #771708
	local desktop="${desktop_exec}${desktop_suffix}" count=0
	while [[ -e ${ED}/usr/share/applications/${desktop}.desktop ]]; do
		desktop="${desktop_exec}-$((++count))${desktop_suffix}"
	done
	desktop="${T}/${desktop}.desktop"

	# Don't append another ";" when a valid category value is provided.
	type=${type%;}${type:+;}

	if [[ -n ${icon} && ${icon} != /* ]] && [[ ${icon} == *.xpm || ${icon} == *.png || ${icon} == *.svg ]]; then
		ewarn "As described in the Icon Theme Specification, icon file extensions are not"
		ewarn "allowed in .desktop files if the value is not an absolute path."
		icon=${icon%.*}
	fi

	cat <<-EOF > "${desktop}" || die
	[Desktop Entry]
	Name=${name}
	Type=Application
	Comment=${DESCRIPTION}
	Exec=${exec}
	TryExec=${exec%% *}
	Icon=${icon}
	Categories=${type}
	EOF

	if [[ ${fields:-=} != *=* ]] ; then
		# 5th arg used to be value to Path=
		ewarn "make_desktop_entry: update your 5th arg to read Path=${fields}"
		fields="Path=${fields}"
	fi
	if [[ -n ${fields} ]]; then
		printf '%b\n' "${fields}" >> "${desktop}" || die
	fi

	(
		# wrap the env here so that the 'insinto' call
		# doesn't corrupt the env of the caller
		insopts -m 0644
		insinto /usr/share/applications
		doins "${desktop}"
	) || die "installing desktop file failed"
}

# @FUNCTION: make_session_desktop
# @USAGE: <title> <command> [command args...]
# @DESCRIPTION:
# Make a GDM/KDM Session file.  The title is the file to execute to start the
# Window Manager.  The command is the name of the Window Manager.
#
# You can set the name of the file via the ${wm} variable.
make_session_desktop() {
	[[ -z $1 ]] && eerror "$0: You must specify the title" && return 1
	[[ -z $2 ]] && eerror "$0: You must specify the command" && return 1

	local title=$1
	local command=$2
	local desktop=${T}/${wm:-${PN}}.desktop
	shift 2

	cat <<-EOF > "${desktop}" || die
	[Desktop Entry]
	Name=${title}
	Comment=This session logs you into ${title}
	Exec=${command} $*
	TryExec=${command}
	Type=XSession
	EOF

	(
	# wrap the env here so that the 'insinto' call
	# doesn't corrupt the env of the caller
	insopts -m 0644
	insinto /usr/share/xsessions
	doins "${desktop}"
	)
}

# @FUNCTION: domenu
# @USAGE: <menus>
# @DESCRIPTION:
# Install the list of .desktop menu files into the appropriate directory
# (/usr/share/applications).
domenu() {
	(
	# wrap the env here so that the 'insinto' call
	# doesn't corrupt the env of the caller
	local i ret=0
	insopts -m 0644
	insinto /usr/share/applications
	for i in "$@" ; do
		if [[ -d ${i} ]] ; then
			doins "${i}"/*.desktop
			((ret|=$?))
		else
			doins "${i}"
			((ret|=$?))
		fi
	done
	exit ${ret}
	)
}

# @FUNCTION: newmenu
# @USAGE: <menu> <newname>
# @DESCRIPTION:
# Like all other new* functions, install the specified menu as newname.
newmenu() {
	(
	# wrap the env here so that the 'insinto' call
	# doesn't corrupt the env of the caller
	insopts -m 0644
	insinto /usr/share/applications
	newins "$@"
	)
}

# @FUNCTION: _iconins
# @INTERNAL
# @DESCRIPTION:
# function for use in doicon and newicon
_iconins() {
	(
	# wrap the env here so that the 'insinto' call
	# doesn't corrupt the env of the caller
	insopts -m 0644
	local funcname=$1; shift
	local size dir
	local context=apps
	local theme=hicolor

	while [[ $# -gt 0 ]] ; do
		case $1 in
		-s|--size)
			if [[ ${2%%x*}x${2%%x*} == "$2" ]] ; then
				size=${2%%x*}
			else
				size=${2}
			fi
			case ${size} in
			16|22|24|32|36|48|64|72|96|128|192|256|512|1024)
				size=${size}x${size};;
			symbolic|scalable)
				;;
			*)
				eerror "${size} is an unsupported icon size!"
				exit 1;;
			esac
			shift 2;;
		-t|--theme)
			theme=${2}
			shift 2;;
		-c|--context)
			context=${2}
			shift 2;;
		*)
			if [[ -z ${size} ]] ; then
				insinto /usr/share/pixmaps
			else
				insinto /usr/share/icons/${theme}/${size}/${context}
			fi

			if [[ ${funcname} == doicon ]] ; then
				if [[ -f $1 ]] ; then
					doins "${1}"
				elif [[ -d $1 ]] ; then
					shopt -s nullglob
					doins "${1}"/*.{png,svg}
					shopt -u nullglob
				else
					eerror "${1} is not a valid file/directory!"
					exit 1
				fi
			else
				break
			fi
			shift 1;;
		esac
	done
	if [[ ${funcname} == newicon ]] ; then
		newins "$@"
	fi
	) || die
}

# @FUNCTION: doicon
# @USAGE: [options] <icons>
# @DESCRIPTION:
# Install icon into the icon directory /usr/share/icons or into
# /usr/share/pixmaps if "--size" is not set.
# This is useful in conjunction with creating desktop/menu files.
#
# @CODE
#  options:
#  -s, --size
#    !!! must specify to install into /usr/share/icons/... !!!
#    size of the icon, like 48 or 48x48
#    supported icon sizes are:
#    16 22 24 32 36 48 64 72 96 128 192 256 512 1024 scalable
#  -c, --context
#    defaults to "apps"
#  -t, --theme
#    defaults to "hicolor"
#
# icons: list of icons
#
# example 1: doicon foobar.png fuqbar.svg suckbar.png
# results in: insinto /usr/share/pixmaps
#             doins foobar.png fuqbar.svg suckbar.png
#
# example 2: doicon -s 48 foobar.png fuqbar.png blobbar.png
# results in: insinto /usr/share/icons/hicolor/48x48/apps
#             doins foobar.png fuqbar.png blobbar.png
# @CODE
doicon() {
	_iconins ${FUNCNAME} "$@"
}

# @FUNCTION: newicon
# @USAGE: [options] <icon> <newname>
# @DESCRIPTION:
# Like doicon, install the specified icon as newname.
#
# @CODE
# example 1: newicon foobar.png NEWNAME.png
# results in: insinto /usr/share/pixmaps
#             newins foobar.png NEWNAME.png
#
# example 2: newicon -s 48 foobar.png NEWNAME.png
# results in: insinto /usr/share/icons/hicolor/48x48/apps
#             newins foobar.png NEWNAME.png
# @CODE
newicon() {
	_iconins ${FUNCNAME} "$@"
}

fi
