# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: desktop.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @SUPPORTED_EAPIS: 7 8
# @BLURB: support for desktop files, menus, and icons

if [[ -z ${_DESKTOP_ECLASS} ]]; then
_DESKTOP_ECLASS=1

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @ECLASS_VARIABLE: _DESKTOP_IDS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Internal array containing any app-ids used by make_desktop_entry() calls.
# Lets us keep track of/avoid duplicate desktop file names.
_DESKTOP_IDS=()

# @FUNCTION: make_desktop_entry
# @USAGE: [--eapi9] <command> [options]
# @DESCRIPTION:
# Make a .desktop file and install it in /usr/share/applications/.
#
# @CODE
# --eapi9:    Switch to getopts style arguments instead of order based
#             As the naming implies, this is off by default for EAPI=[78],
#             but mandated by future EAPI.
# command:    Exec command the app is being run with, also base for TryExec
# ---         Options:
# name:       Name that will show up in the menu; defaults to PN
#             with --eapi9: must not contain arguments, use --args for that
# icon:       Icon to use with the menu entry; defaults to PN
#             this can be relative (to /usr/share/pixmaps) or
#             a full path to an icon
# categories: Categories for this kind of application. Examples:
#             https://specifications.freedesktop.org/menu-spec/latest/apa.html
#             if unset, function tries to guess from package's category
# entry:      Key=Value entry to append to the desktop file;
#             with --eapi9: multiple allowed; old style: a printf string
# ---         Additional parameters available using --eapi9:
# args:       Arguments (binary params and desktop spec field codes) to add
#             to Exec value, separated by a space if multiple
# desktopid:  <desktopid>.desktop will be created. Must be same as "app id"
#             defined in code (including reverse qualified domain if set);
#             defaults to <command>
# comment:    Comment (menu entry tooltip), defaults to DESCRIPTION
# force:      Force-write resulting desktop file (overwrite existing)
# @CODE
#
# Example usage:
# @CODE
# Deprecated, in order:
#   <command> [name] [icon] [categories] [entries...]
# New style:
#   --eapi9 <command> [-a args] [-d desktopid] [-C comment] [-i icon]
#   --eapi9 <command> [-n name] [-e entry...] [-c categories]
# @CODE
make_desktop_entry() {
	local eapi9
	if [[ -n ${1} ]]; then
		case ${EAPI} in
			7|8)
				if [[ ${1} == --eapi9 ]]; then
					eapi9=1
					shift
				fi
				;;
			*)
				if [[ ${1} == --eapi9 ]]; then
					ewarn "make_desktop_entry: --eapi9 arg is obsolete in EAPI-${EAPI} and may be cleaned up now."
					shift
				fi
				eapi9=1
				;;
		esac
	fi
	[[ -z ${1} ]] && die "make_desktop_entry: You must specify at least a command"

	if [[ ${eapi9} ]]; then
		local args cats cmd comment desktopid entries force icon name
		while [[ $# -gt 0 ]] ; do
			case "${1}" in
			-a|--args)
				args="${2}";         shift 2 ;;
			-c|--categories)
				cats="${2}";         shift 2 ;;
			-C|--comment)
				comment="${2}";      shift 2 ;;
			-d|--desktopid)
				desktopid="${2}";    shift 2 ;;
			-e|--entry)
				entries+=( "${2}" ); shift 2 ;;
			-f|--force)
				force=1;             shift 1 ;;
			-i|--icon)
				icon="${2}";         shift 2 ;;
			-n|--name)
				name="${2}";         shift 2 ;;
			*)
				if [[ -z ${cmd} ]] ; then
					cmd="${1}"
				else
					die "make_desktop_entry: Can only take one command! First got: ${cmd}; then got: ${1}"
				fi
				shift ;;
			esac
		done
		[[ -z ${cmd} ]] && die "make_desktop_entry: You must specify at least a command"
		[[ -z ${name} ]] && name=${PN}
		[[ -z ${icon} ]] && icon=${PN}
	else
		local cmd=${1}
		local name=${2:-${PN}}
		local icon=${3:-${PN}}
		local cats=${4}
		local entries=${5}
	fi

	[[ -z ${comment} ]] && comment="${DESCRIPTION}"

	if [[ -z ${cats} ]] ; then
		local catmaj=${CATEGORY%%-*}
		local catmin=${CATEGORY##*-}
		case ${catmaj} in
			app)
				case ${catmin} in
					accessibility) cats="Utility;Accessibility";;
					admin)         cats=System;;
					antivirus)     cats=System;;
					arch)          cats="Utility;Archiving";;
					backup)        cats="Utility;Archiving";;
					cdr)           cats="AudioVideo;DiscBurning";;
					dicts)         cats="Office;Dictionary";;
					doc)           cats=Documentation;;
					editors)       cats="Utility;TextEditor";;
					emacs)         cats="Development;TextEditor";;
					emulation)     cats="System;Emulator";;
					laptop)        cats="Settings;HardwareSettings";;
					office)        cats=Office;;
					pda)           cats="Office;PDA";;
					vim)           cats="Development;TextEditor";;
					xemacs)        cats="Development;TextEditor";;
				esac
				;;

			dev)
				cats="Development"
				;;

			games)
				case ${catmin} in
					action|fps) cats=ActionGame;;
					arcade)     cats=ArcadeGame;;
					board)      cats=BoardGame;;
					emulation)  cats=Emulator;;
					kids)       cats=KidsGame;;
					puzzle)     cats=LogicGame;;
					roguelike)  cats=RolePlaying;;
					rpg)        cats=RolePlaying;;
					simulation) cats=Simulation;;
					sports)     cats=SportsGame;;
					strategy)   cats=StrategyGame;;
				esac
				cats="Game;${cats}"
				;;

			gnome)
				cats="Gnome;GTK"
				;;

			kde)
				cats="KDE;Qt"
				;;

			mail)
				cats="Network;Email"
				;;

			media)
				case ${catmin} in
					gfx)
						cats=Graphics
						;;
					*)
						case ${catmin} in
							radio) cats=Tuner;;
							sound) cats=Audio;;
							tv)    cats=TV;;
							video) cats=Video;;
						esac
						cats="AudioVideo;${cats}"
						;;
				esac
				;;

			net)
				case ${catmin} in
					dialup) cats=Dialup;;
					ftp)    cats=FileTransfer;;
					im)     cats=InstantMessaging;;
					irc)    cats=IRCClient;;
					mail)   cats=Email;;
					news)   cats=News;;
					nntp)   cats=News;;
					p2p)    cats=FileTransfer;;
					voip)   cats=Telephony;;
				esac
				cats="Network;${cats}"
				;;

			sci)
				case ${catmin} in
					astro*)  cats=Astronomy;;
					bio*)    cats=Biology;;
					calc*)   cats=Calculator;;
					chem*)   cats=Chemistry;;
					elec*)   cats=Electronics;;
					geo*)    cats=Geology;;
					math*)   cats=Math;;
					physics) cats=Physics;;
					visual*) cats=DataVisualization;;
				esac
				cats="Education;Science;${cats}"
				;;

			sys)
				cats="System"
				;;

			www)
				case ${catmin} in
					client) cats=WebBrowser;;
				esac
				cats="Network;${cats}"
				;;

			*)
				cats=
				;;
		esac
	fi

	if [[ ${eapi9} ]]; then
		if [[ -z ${desktopid} ]]; then
			if [[ ${cmd} =~ .+[[:space:]].+ ]]; then
				die "make_desktop_entry: --desktopid must be provided when <command> contains a space"
			fi
			desktopid="${cmd##*/}"
		fi
		if [[ ! ${desktopid} =~ ^[A-Za-z0-9._-]+$ ]]; then
			die "make_desktop_entry: <desktopid> must only consist of ASCII letters, digits, dash, underscore and dots"
		fi
		if [[ ${_DESKTOP_IDS[*]} =~ (^|[[:space:]])"${desktopid}"($|[[:space:]]) ]]; then
			die "make_desktop_entry: desktopid \"${desktopid}\" already used in a previous call, choose a different one"
		else
			_DESKTOP_IDS+=( "${desktopid}" )
		fi
		local desktop="${T}/${desktopid}.desktop"
		if [[ ! ${force} && -e ${ED}/usr/share/applications/${desktopid}.desktop ]]; then
			die "make_desktop_entry: desktopid \"${desktopid}\" already exists, must be unique"
		fi
	else
		local desktop_exec="${cmd%%[[:space:]]*}"
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
	fi

	# Don't append another ";" when a valid category value is provided.
	cats=${cats%;}${cats:+;}

	if [[ -n ${icon} && ${icon} != /* ]] && [[ ${icon} == *.xpm || ${icon} == *.png || ${icon} == *.svg ]]; then
		ewarn "As described in the Icon Theme Specification, icon file extensions are not"
		ewarn "allowed in .desktop files if the value is not an absolute path."
		icon=${icon%.*}
	fi

	cat > "${desktop}" <<- _EOF_ || die
		[Desktop Entry]
		Type=Application
		Name=${name}
		Comment=${comment}
		Icon=${icon}
		Categories=${cats}
	_EOF_

	if [[ ${eapi9} ]]; then
		local cmd_args="${cmd} ${args}"
		cat >> "${desktop}" <<- _EOF_ || die
			Exec=${cmd_args%[[:space:]]}
			TryExec=${cmd}
		_EOF_
	else
		cat >> "${desktop}" <<- _EOF_ || die
			Exec=${cmd}
			TryExec=${cmd%% *}
		_EOF_
	fi

	if [[ ${eapi9} && -n ${entries} ]]; then
		local entry
		for entry in ${entries[@]}; do
			if [[ ${entry} =~ ^[A-Za-z0-9-]+=.* ]]; then
				printf "%s\n" "${entry}" >> "${desktop}" || die
			else
				die "make_desktop_entry: <entry> \"${entry}\" rejected; must be passed a Key=Value pair"
			fi
		done
	else
		if [[ ${entries:-=} != *=* ]]; then
			# 5th arg used to be value to Path=
			ewarn "make_desktop_entry: update your 5th arg to read Path=${entries}"
			entries="Path=${entries}"
		fi
		if [[ -n ${entries} ]]; then
			printf '%b\n' "${entries}" >> "${desktop}" || die
		fi
	fi

	(
		# wrap the env here so that the 'insinto' call
		# doesn't corrupt the env of the caller
		insopts -m 0644
		insinto /usr/share/applications
		doins "${desktop}"
	)
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
	)
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
