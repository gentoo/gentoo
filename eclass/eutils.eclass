# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: eutils.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @BLURB: many extra (but common) functions that are used in ebuilds
# @DESCRIPTION:
# The eutils eclass contains a suite of functions that complement
# the ones that ebuild.sh already contain.  The idea is that the functions
# are not required in all ebuilds but enough utilize them to have a common
# home rather than having multiple ebuilds implementing the same thing.
#
# Due to the nature of this eclass, some functions may have maintainers
# different from the overall eclass!

if [[ -z ${_EUTILS_ECLASS} ]]; then
_EUTILS_ECLASS=1

# implicitly inherited (now split) eclasses
case ${EAPI:-0} in
0|1|2|3|4|5|6)
	inherit epatch estack ltprune multilib toolchain-funcs
	;;
esac

# @FUNCTION: eqawarn
# @USAGE: [message]
# @DESCRIPTION:
# Proxy to ewarn for package managers that don't provide eqawarn and use the PM
# implementation if available. Reuses PORTAGE_ELOG_CLASSES as set by the dev
# profile.
if ! declare -F eqawarn >/dev/null ; then
	eqawarn() {
		has qa ${PORTAGE_ELOG_CLASSES} && ewarn "$@"
		:
	}
fi

# @FUNCTION: ecvs_clean
# @USAGE: [list of dirs]
# @DESCRIPTION:
# Remove CVS directories recursiveley.  Useful when a source tarball contains
# internal CVS directories.  Defaults to $PWD.
ecvs_clean() {
	[[ $# -eq 0 ]] && set -- .
	find "$@" -type d -name 'CVS' -prune -print0 | xargs -0 rm -rf
	find "$@" -type f -name '.cvs*' -print0 | xargs -0 rm -rf
}

# @FUNCTION: esvn_clean
# @USAGE: [list of dirs]
# @DESCRIPTION:
# Remove .svn directories recursiveley.  Useful when a source tarball contains
# internal Subversion directories.  Defaults to $PWD.
esvn_clean() {
	[[ $# -eq 0 ]] && set -- .
	find "$@" -type d -name '.svn' -prune -print0 | xargs -0 rm -rf
}

# @FUNCTION: egit_clean
# @USAGE: [list of dirs]
# @DESCRIPTION:
# Remove .git* directories/files recursiveley.  Useful when a source tarball
# contains internal Git directories.  Defaults to $PWD.
egit_clean() {
	[[ $# -eq 0 ]] && set -- .
	find "$@" -type d -name '.git*' -prune -print0 | xargs -0 rm -rf
}

# @FUNCTION: emktemp
# @USAGE: [temp dir]
# @DESCRIPTION:
# Cheap replacement for when debianutils (and thus mktemp)
# does not exist on the users system.
emktemp() {
	local exe="touch"
	[[ $1 == -d ]] && exe="mkdir" && shift
	local topdir=$1

	if [[ -z ${topdir} ]] ; then
		[[ -z ${T} ]] \
			&& topdir="/tmp" \
			|| topdir=${T}
	fi

	if ! type -P mktemp > /dev/null ; then
		# system lacks `mktemp` so we have to fake it
		local tmp=/
		while [[ -e ${tmp} ]] ; do
			tmp=${topdir}/tmp.${RANDOM}.${RANDOM}.${RANDOM}
		done
		${exe} "${tmp}" || ${exe} -p "${tmp}"
		echo "${tmp}"
	else
		# the args here will give slightly wierd names on BSD,
		# but should produce a usable file on all userlands
		if [[ ${exe} == "touch" ]] ; then
			TMPDIR="${topdir}" mktemp -t tmp.XXXXXXXXXX
		else
			TMPDIR="${topdir}" mktemp -dt tmp.XXXXXXXXXX
		fi
	fi
}

# @FUNCTION: edos2unix
# @USAGE: <file> [more files ...]
# @DESCRIPTION:
# A handy replacement for dos2unix, recode, fixdos, etc...  This allows you
# to remove all of these text utilities from DEPEND variables because this
# is a script based solution.  Just give it a list of files to convert and
# they will all be changed from the DOS CRLF format to the UNIX LF format.
edos2unix() {
	[[ $# -eq 0 ]] && return 0
	sed -i 's/\r$//' -- "$@" || die
}

# @FUNCTION: make_desktop_entry
# @USAGE: make_desktop_entry(<command>, [name], [icon], [type], [fields])
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
	local slot=${SLOT%/*}
	if [[ ${slot} == "0" ]] ; then
		local desktop_name="${PN}"
	else
		local desktop_name="${PN}-${slot}"
	fi
	local desktop="${T}/$(echo ${exec} | sed 's:[[:space:]/:]:_:g')-${desktop_name}.desktop"
	#local desktop=${T}/${exec%% *:-${desktop_name}}.desktop

	# Don't append another ";" when a valid category value is provided.
	type=${type%;}${type:+;}

	eshopts_push -s extglob
	if [[ -n ${icon} && ${icon} != /* ]] && [[ ${icon} == *.xpm || ${icon} == *.png || ${icon} == *.svg ]]; then
		ewarn "As described in the Icon Theme Specification, icon file extensions are not"
		ewarn "allowed in .desktop files if the value is not an absolute path."
		icon=${icon%.@(xpm|png|svg)}
	fi
	eshopts_pop

	cat <<-EOF > "${desktop}"
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
	[[ -n ${fields} ]] && printf '%b\n' "${fields}" >> "${desktop}"

	(
		# wrap the env here so that the 'insinto' call
		# doesn't corrupt the env of the caller
		insinto /usr/share/applications
		doins "${desktop}"
	) || die "installing desktop file failed"
}

# @FUNCTION: _eutils_eprefix_init
# @INTERNAL
# @DESCRIPTION:
# Initialized prefix variables for EAPI<3.
_eutils_eprefix_init() {
	has "${EAPI:-0}" 0 1 2 && : ${ED:=${D}} ${EPREFIX:=} ${EROOT:=${ROOT}}
}

# @FUNCTION: validate_desktop_entries
# @USAGE: [directories]
# @DESCRIPTION:
# Validate desktop entries using desktop-file-utils
validate_desktop_entries() {
	eqawarn "validate_desktop_entries is deprecated and should be not be used."
	eqawarn ".desktop file validation is done implicitly by Portage now."

	_eutils_eprefix_init
	if [[ -x "${EPREFIX}"/usr/bin/desktop-file-validate ]] ; then
		einfo "Checking desktop entry validity"
		local directories=""
		for d in /usr/share/applications $@ ; do
			[[ -d ${ED}${d} ]] && directories="${directories} ${ED}${d}"
		done
		if [[ -n ${directories} ]] ; then
			for FILE in $(find ${directories} -name "*\.desktop" \
							-not -path '*.hidden*' | sort -u 2>/dev/null)
			do
				local temp=$(desktop-file-validate ${FILE} | grep -v "warning:" | \
								sed -e "s|error: ||" -e "s|${FILE}:|--|g" )
				[[ -n $temp ]] && elog ${temp/--/${FILE/${ED}/}:}
			done
		fi
		echo ""
	else
		einfo "Passing desktop entry validity check. Install dev-util/desktop-file-utils, if you want to help to improve Gentoo."
	fi
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

	cat <<-EOF > "${desktop}"
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
	local i j ret=0
	insinto /usr/share/applications
	for i in "$@" ; do
		if [[ -f ${i} ]] ; then
			doins "${i}"
			((ret+=$?))
		elif [[ -d ${i} ]] ; then
			for j in "${i}"/*.desktop ; do
				doins "${j}"
				((ret+=$?))
			done
		else
			((++ret))
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
			16|22|24|32|36|48|64|72|96|128|192|256|512)
				size=${size}x${size};;
			scalable)
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
#    16 22 24 32 36 48 64 72 96 128 192 256 512 scalable
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

# @FUNCTION: strip-linguas
# @USAGE: [<allow LINGUAS>|<-i|-u> <directories of .po files>]
# @DESCRIPTION:
# Make sure that LINGUAS only contains languages that
# a package can support.  The first form allows you to
# specify a list of LINGUAS.  The -i builds a list of po
# files found in all the directories and uses the
# intersection of the lists.  The -u builds a list of po
# files found in all the directories and uses the union
# of the lists.
strip-linguas() {
	local ls newls nols
	if [[ $1 == "-i" ]] || [[ $1 == "-u" ]] ; then
		local op=$1; shift
		ls=$(find "$1" -name '*.po' -exec basename {} .po ';'); shift
		local d f
		for d in "$@" ; do
			if [[ ${op} == "-u" ]] ; then
				newls=${ls}
			else
				newls=""
			fi
			for f in $(find "$d" -name '*.po' -exec basename {} .po ';') ; do
				if [[ ${op} == "-i" ]] ; then
					has ${f} ${ls} && newls="${newls} ${f}"
				else
					has ${f} ${ls} || newls="${newls} ${f}"
				fi
			done
			ls=${newls}
		done
	else
		ls="$@"
	fi

	nols=""
	newls=""
	for f in ${LINGUAS} ; do
		if has ${f} ${ls} ; then
			newls="${newls} ${f}"
		else
			nols="${nols} ${f}"
		fi
	done
	[[ -n ${nols} ]] \
		&& einfo "Sorry, but ${PN} does not support the LINGUAS:" ${nols}
	export LINGUAS=${newls:1}
}

# @FUNCTION: preserve_old_lib
# @USAGE: <libs to preserve> [more libs]
# @DESCRIPTION:
# These functions are useful when a lib in your package changes ABI SONAME.
# An example might be from libogg.so.0 to libogg.so.1.  Removing libogg.so.0
# would break packages that link against it.  Most people get around this
# by using the portage SLOT mechanism, but that is not always a relevant
# solution, so instead you can call this from pkg_preinst.  See also the
# preserve_old_lib_notify function.
preserve_old_lib() {
	_eutils_eprefix_init
	if [[ ${EBUILD_PHASE} != "preinst" ]] ; then
		eerror "preserve_old_lib() must be called from pkg_preinst() only"
		die "Invalid preserve_old_lib() usage"
	fi
	[[ -z $1 ]] && die "Usage: preserve_old_lib <library to preserve> [more libraries to preserve]"

	# let portage worry about it
	has preserve-libs ${FEATURES} && return 0

	local lib dir
	for lib in "$@" ; do
		[[ -e ${EROOT}/${lib} ]] || continue
		dir=${lib%/*}
		dodir ${dir} || die "dodir ${dir} failed"
		cp "${EROOT}"/${lib} "${ED}"/${lib} || die "cp ${lib} failed"
		touch "${ED}"/${lib}
	done
}

# @FUNCTION: preserve_old_lib_notify
# @USAGE: <libs to notify> [more libs]
# @DESCRIPTION:
# Spit helpful messages about the libraries preserved by preserve_old_lib.
preserve_old_lib_notify() {
	if [[ ${EBUILD_PHASE} != "postinst" ]] ; then
		eerror "preserve_old_lib_notify() must be called from pkg_postinst() only"
		die "Invalid preserve_old_lib_notify() usage"
	fi

	# let portage worry about it
	has preserve-libs ${FEATURES} && return 0

	_eutils_eprefix_init

	local lib notice=0
	for lib in "$@" ; do
		[[ -e ${EROOT}/${lib} ]] || continue
		if [[ ${notice} -eq 0 ]] ; then
			notice=1
			ewarn "Old versions of installed libraries were detected on your system."
			ewarn "In order to avoid breaking packages that depend on these old libs,"
			ewarn "the libraries are not being removed.  You need to run revdep-rebuild"
			ewarn "in order to remove these old dependencies.  If you do not have this"
			ewarn "helper program, simply emerge the 'gentoolkit' package."
			ewarn
		fi
		ewarn "  # revdep-rebuild --library '${lib}' && rm '${lib}'"
	done
}

# @FUNCTION: built_with_use
# @USAGE: [--hidden] [--missing <action>] [-a|-o] <DEPEND ATOM> <List of USE flags>
# @DESCRIPTION:
#
# Deprecated: Use EAPI 2 use deps in DEPEND|RDEPEND and with has_version calls.
#
# A temporary hack until portage properly supports DEPENDing on USE
# flags being enabled in packages.  This will check to see if the specified
# DEPEND atom was built with the specified list of USE flags.  The
# --missing option controls the behavior if called on a package that does
# not actually support the defined USE flags (aka listed in IUSE).
# The default is to abort (call die).  The -a and -o flags control
# the requirements of the USE flags.  They correspond to "and" and "or"
# logic.  So the -a flag means all listed USE flags must be enabled
# while the -o flag means at least one of the listed IUSE flags must be
# enabled.  The --hidden option is really for internal use only as it
# means the USE flag we're checking is hidden expanded, so it won't be found
# in IUSE like normal USE flags.
#
# Remember that this function isn't terribly intelligent so order of optional
# flags matter.
built_with_use() {
	_eutils_eprefix_init
	local hidden="no"
	if [[ $1 == "--hidden" ]] ; then
		hidden="yes"
		shift
	fi

	local missing_action="die"
	if [[ $1 == "--missing" ]] ; then
		missing_action=$2
		shift ; shift
		case ${missing_action} in
			true|false|die) ;;
			*) die "unknown action '${missing_action}'";;
		esac
	fi

	local opt=$1
	[[ ${opt:0:1} = "-" ]] && shift || opt="-a"

	local PKG=$(best_version $1)
	[[ -z ${PKG} ]] && die "Unable to resolve $1 to an installed package"
	shift

	local USEFILE=${EROOT}/var/db/pkg/${PKG}/USE
	local IUSEFILE=${EROOT}/var/db/pkg/${PKG}/IUSE

	# if the IUSE file doesn't exist, the read will error out, we need to handle
	# this gracefully
	if [[ ! -e ${USEFILE} ]] || [[ ! -e ${IUSEFILE} && ${hidden} == "no" ]] ; then
		case ${missing_action} in
			true)	return 0;;
			false)	return 1;;
			die)	die "Unable to determine what USE flags $PKG was built with";;
		esac
	fi

	if [[ ${hidden} == "no" ]] ; then
		local IUSE_BUILT=( $(<"${IUSEFILE}") )
		# Don't check USE_EXPAND #147237
		local expand
		for expand in $(echo ${USE_EXPAND} | tr '[:upper:]' '[:lower:]') ; do
			if [[ $1 == ${expand}_* ]] ; then
				expand=""
				break
			fi
		done
		if [[ -n ${expand} ]] ; then
			if ! has $1 ${IUSE_BUILT[@]#[-+]} ; then
				case ${missing_action} in
					true)  return 0;;
					false) return 1;;
					die)   die "$PKG does not actually support the $1 USE flag!";;
				esac
			fi
		fi
	fi

	local USE_BUILT=$(<${USEFILE})
	while [[ $# -gt 0 ]] ; do
		if [[ ${opt} = "-o" ]] ; then
			has $1 ${USE_BUILT} && return 0
		else
			has $1 ${USE_BUILT} || return 1
		fi
		shift
	done
	[[ ${opt} = "-a" ]]
}

# If an overlay has eclass overrides, but doesn't actually override the
# libtool.eclass, we'll have ECLASSDIR pointing to the active overlay's
# eclass/ dir, but libtool.eclass is still in the main Gentoo tree.  So
# add a check to locate the ELT-patches/ regardless of what's going on.
# Note: Duplicated in libtool.eclass.
_EUTILS_ECLASSDIR_LOCAL=${BASH_SOURCE[0]%/*}
eutils_elt_patch_dir() {
	local d="${ECLASSDIR}/ELT-patches"
	if [[ ! -d ${d} ]] ; then
		d="${_EUTILS_ECLASSDIR_LOCAL}/ELT-patches"
	fi
	echo "${d}"
}

# @FUNCTION: epunt_cxx
# @USAGE: [dir to scan]
# @DESCRIPTION:
# Many configure scripts wrongly bail when a C++ compiler could not be
# detected.  If dir is not specified, then it defaults to ${S}.
#
# https://bugs.gentoo.org/73450
epunt_cxx() {
	local dir=$1
	[[ -z ${dir} ]] && dir=${S}
	ebegin "Removing useless C++ checks"
	local f p any_found
	while IFS= read -r -d '' f; do
		for p in "$(eutils_elt_patch_dir)"/nocxx/*.patch ; do
			if patch --no-backup-if-mismatch -p1 "${f}" "${p}" >/dev/null ; then
				any_found=1
				break
			fi
		done
	done < <(find "${dir}" -name configure -print0)

	if [[ -z ${any_found} ]]; then
		eqawarn "epunt_cxx called unnecessarily (no C++ checks to punt)."
	fi
	eend 0
}

# @FUNCTION: make_wrapper
# @USAGE: <wrapper> <target> [chdir] [libpaths] [installpath]
# @DESCRIPTION:
# Create a shell wrapper script named wrapper in installpath
# (defaults to the bindir) to execute target (default of wrapper) by
# first optionally setting LD_LIBRARY_PATH to the colon-delimited
# libpaths followed by optionally changing directory to chdir.
make_wrapper() {
	_eutils_eprefix_init
	local wrapper=$1 bin=$2 chdir=$3 libdir=$4 path=$5
	local tmpwrapper=$(emktemp)

	(
	echo '#!/bin/sh'
	[[ -n ${chdir} ]] && printf 'cd "%s"\n' "${EPREFIX}${chdir}"
	if [[ -n ${libdir} ]] ; then
		local var
		if [[ ${CHOST} == *-darwin* ]] ; then
			var=DYLD_LIBRARY_PATH
		else
			var=LD_LIBRARY_PATH
		fi
		cat <<-EOF
			if [ "\${${var}+set}" = "set" ] ; then
				export ${var}="\${${var}}:${EPREFIX}${libdir}"
			else
				export ${var}="${EPREFIX}${libdir}"
			fi
		EOF
	fi
	# We don't want to quote ${bin} so that people can pass complex
	# things as ${bin} ... "./someprog --args"
	printf 'exec %s "$@"\n' "${bin/#\//${EPREFIX}/}"
	) > "${tmpwrapper}"
	chmod go+rx "${tmpwrapper}"

	if [[ -n ${path} ]] ; then
		(
		exeinto "${path}"
		newexe "${tmpwrapper}" "${wrapper}"
		) || die
	else
		newbin "${tmpwrapper}" "${wrapper}" || die
	fi
}

# @FUNCTION: path_exists
# @USAGE: [-a|-o] <paths>
# @DESCRIPTION:
# Check if the specified paths exist.  Works for all types of paths
# (files/dirs/etc...).  The -a and -o flags control the requirements
# of the paths.  They correspond to "and" and "or" logic.  So the -a
# flag means all the paths must exist while the -o flag means at least
# one of the paths must exist.  The default behavior is "and".  If no
# paths are specified, then the return value is "false".
path_exists() {
	local opt=$1
	[[ ${opt} == -[ao] ]] && shift || opt="-a"

	# no paths -> return false
	# same behavior as: [[ -e "" ]]
	[[ $# -eq 0 ]] && return 1

	local p r=0
	for p in "$@" ; do
		[[ -e ${p} ]]
		: $(( r += $? ))
	done

	case ${opt} in
		-a) return $(( r != 0 )) ;;
		-o) return $(( r == $# )) ;;
	esac
}

# @FUNCTION: use_if_iuse
# @USAGE: <flag>
# @DESCRIPTION:
# Return true if the given flag is in USE and IUSE.
#
# Note that this function should not be used in the global scope.
use_if_iuse() {
	in_iuse $1 || return 1
	use $1
}

# @FUNCTION: optfeature
# @USAGE: <short description> <package atom to match> [other atoms]
# @DESCRIPTION:
# Print out a message suggesting an optional package (or packages) which
# provide the described functionality
#
# The following snippet would suggest app-misc/foo for optional foo support,
# app-misc/bar or app-misc/baz[bar] for optional bar support
# and either both app-misc/a and app-misc/b or app-misc/c for alphabet support.
# @CODE
#	optfeature "foo support" app-misc/foo
#	optfeature "bar support" app-misc/bar app-misc/baz[bar]
#	optfeature "alphabet support" "app-misc/a app-misc/b" app-misc/c
# @CODE
optfeature() {
	debug-print-function ${FUNCNAME} "$@"
	local i j msg
	local desc=$1
	local flag=0
	shift
	for i; do
		for j in ${i}; do
			if has_version "${j}"; then
				flag=1
			else
				flag=0
				break
			fi
		done
		if [[ ${flag} -eq 1 ]]; then
			break
		fi
	done
	if [[ ${flag} -eq 0 ]]; then
		for i; do
			msg=" "
			for j in ${i}; do
				msg+=" ${j} and"
			done
			msg="${msg:0: -4} for ${desc}"
			elog "${msg}"
		done
	fi
}

check_license() {
	die "you no longer need this as portage supports ACCEPT_LICENSE itself"
}

case ${EAPI:-0} in
0|1|2)

# @FUNCTION: epause
# @USAGE: [seconds]
# @DESCRIPTION:
# Sleep for the specified number of seconds (default of 5 seconds).  Useful when
# printing a message the user should probably be reading and often used in
# conjunction with the ebeep function.  If the EPAUSE_IGNORE env var is set,
# don't wait at all. Defined in EAPIs 0 1 and 2.
epause() {
	[[ -z ${EPAUSE_IGNORE} ]] && sleep ${1:-5}
}

# @FUNCTION: ebeep
# @USAGE: [number of beeps]
# @DESCRIPTION:
# Issue the specified number of beeps (default of 5 beeps).  Useful when
# printing a message the user should probably be reading and often used in
# conjunction with the epause function.  If the EBEEP_IGNORE env var is set,
# don't beep at all. Defined in EAPIs 0 1 and 2.
ebeep() {
	local n
	if [[ -z ${EBEEP_IGNORE} ]] ; then
		for ((n=1 ; n <= ${1:-5} ; n++)) ; do
			echo -ne "\a"
			sleep 0.1 &>/dev/null ; sleep 0,1 &>/dev/null
			echo -ne "\a"
			sleep 1
		done
	fi
}

;;
*)

ebeep() {
	ewarn "QA Notice: ebeep is not defined in EAPI=${EAPI}, please file a bug at https://bugs.gentoo.org"
}

epause() {
	ewarn "QA Notice: epause is not defined in EAPI=${EAPI}, please file a bug at https://bugs.gentoo.org"
}

;;
esac

case ${EAPI:-0} in
0|1|2|3|4)

# @FUNCTION: usex
# @USAGE: <USE flag> [true output] [false output] [true suffix] [false suffix]
# @DESCRIPTION:
# Proxy to declare usex for package managers or EAPIs that do not provide it
# and use the package manager implementation when available (i.e. EAPI >= 5).
# If USE flag is set, echo [true output][true suffix] (defaults to "yes"),
# otherwise echo [false output][false suffix] (defaults to "no").
usex() { use "$1" && echo "${2-yes}$4" || echo "${3-no}$5" ; } #382963

;;
esac

case ${EAPI:-0} in
0|1|2|3|4|5)

# @FUNCTION: einstalldocs
# @DESCRIPTION:
# Install documentation using DOCS and HTML_DOCS.
#
# If DOCS is declared and non-empty, all files listed in it are
# installed. The files must exist, otherwise the function will fail.
# In EAPI 4 and subsequent EAPIs DOCS may specify directories as well,
# in other EAPIs using directories is unsupported.
#
# If DOCS is not declared, the files matching patterns given
# in the default EAPI implementation of src_install will be installed.
# If this is undesired, DOCS can be set to empty value to prevent any
# documentation from being installed.
#
# If HTML_DOCS is declared and non-empty, all files and/or directories
# listed in it are installed as HTML docs (using dohtml).
#
# Both DOCS and HTML_DOCS can either be an array or a whitespace-
# separated list. Whenever directories are allowed, '<directory>/.' may
# be specified in order to install all files within the directory
# without creating a sub-directory in docdir.
#
# Passing additional options to dodoc and dohtml is not supported.
# If you needed such a thing, you need to call those helpers explicitly.
einstalldocs() {
	debug-print-function ${FUNCNAME} "${@}"

	local dodoc_opts=-r
	has ${EAPI} 0 1 2 3 && dodoc_opts=

	if ! declare -p DOCS &>/dev/null ; then
		local d
		for d in README* ChangeLog AUTHORS NEWS TODO CHANGES \
				THANKS BUGS FAQ CREDITS CHANGELOG ; do
			if [[ -s ${d} ]] ; then
				dodoc "${d}" || die
			fi
		done
	elif [[ $(declare -p DOCS) == "declare -a"* ]] ; then
		if [[ ${DOCS[@]} ]] ; then
			dodoc ${dodoc_opts} "${DOCS[@]}" || die
		fi
	else
		if [[ ${DOCS} ]] ; then
			dodoc ${dodoc_opts} ${DOCS} || die
		fi
	fi

	if [[ $(declare -p HTML_DOCS 2>/dev/null) == "declare -a"* ]] ; then
		if [[ ${HTML_DOCS[@]} ]] ; then
			dohtml -r "${HTML_DOCS[@]}" || die
		fi
	else
		if [[ ${HTML_DOCS} ]] ; then
			dohtml -r ${HTML_DOCS} || die
		fi
	fi

	return 0
}

# @FUNCTION: in_iuse
# @USAGE: <flag>
# @DESCRIPTION:
# Determines whether the given flag is in IUSE. Strips IUSE default prefixes
# as necessary.
#
# Note that this function should not be used in the global scope.
in_iuse() {
	debug-print-function ${FUNCNAME} "${@}"
	[[ ${#} -eq 1 ]] || die "Invalid args to ${FUNCNAME}()"

	local flag=${1}
	local liuse=( ${IUSE} )

	has "${flag}" "${liuse[@]#[+-]}"
}

;;
esac

fi
