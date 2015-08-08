# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: games
# @MAINTAINER:
# Games team <games@gentoo.org>
# @BLURB: Standardizing the install of games.
# @DESCRIPTION:
# This eclass makes sure that games are consistently handled in gentoo.
# It installs game files by default in FHS-compatible directories
# like /usr/share/games and sets more restrictive permissions in order
# to avoid some security bugs.
#
# The installation directories as well as the user and group files are
# installed as can be controlled by the user. See the variables like
# GAMES_BINDIR, GAMES_USER etc. below. These are NOT supposed to be set
# by ebuilds!
#
# For a general guide on writing games ebuilds, see:
# https://wiki.gentoo.org/wiki/Project:Games/Ebuild_howto


if [[ -z ${_GAMES_ECLASS} ]]; then
_GAMES_ECLASS=1

inherit base multilib toolchain-funcs eutils user

case ${EAPI:-0} in
	0|1) EXPORT_FUNCTIONS pkg_setup src_compile pkg_preinst pkg_postinst ;;
	2|3|4|5) EXPORT_FUNCTIONS pkg_setup src_configure src_compile pkg_preinst pkg_postinst ;;
	*) die "no support for EAPI=${EAPI} yet" ;;
esac

if [[ ${CATEGORY}/${PN} != "games-misc/games-envd" ]] ; then
	# environment file
	RDEPEND="games-misc/games-envd"
fi

# @ECLASS-VARIABLE: GAMES_PREFIX
# @DESCRIPTION:
# Prefix where to install games, mostly used by GAMES_BINDIR. Games data should
# still go into GAMES_DATADIR. May be set by the user.
GAMES_PREFIX=${GAMES_PREFIX:-/usr/games}

# @ECLASS-VARIABLE: GAMES_PREFIX_OPT
# @DESCRIPTION:
# Prefix where to install precompiled/blob games, usually followed by
# package name. May be set by the user.
GAMES_PREFIX_OPT=${GAMES_PREFIX_OPT:-/opt}

# @ECLASS-VARIABLE: GAMES_DATADIR
# @DESCRIPTION:
# Base directory where to install game data files, usually followed by
# package name. May be set by the user.
GAMES_DATADIR=${GAMES_DATADIR:-/usr/share/games}

# @ECLASS-VARIABLE: GAMES_DATADIR_BASE
# @DESCRIPTION:
# Similar to GAMES_DATADIR, but only used when a package auto appends 'games'
# to the path. May be set by the user.
GAMES_DATADIR_BASE=${GAMES_DATADIR_BASE:-/usr/share}

# @ECLASS-VARIABLE: GAMES_SYSCONFDIR
# @DESCRIPTION:
# Where to install global games configuration files, usually followed by
# package name. May be set by the user.
GAMES_SYSCONFDIR=${GAMES_SYSCONFDIR:-/etc/games}

# @ECLASS-VARIABLE: GAMES_STATEDIR
# @DESCRIPTION:
# Where to install/store global variable game data, usually followed by
# package name. May be set by the user.
GAMES_STATEDIR=${GAMES_STATEDIR:-/var/games}

# @ECLASS-VARIABLE: GAMES_LOGDIR
# @DESCRIPTION:
# Where to store global game log files, usually followed by
# package name. May be set by the user.
GAMES_LOGDIR=${GAMES_LOGDIR:-/var/log/games}

# @ECLASS-VARIABLE: GAMES_BINDIR
# @DESCRIPTION:
# Where to install the game binaries. May be set by the user. This is in PATH.
GAMES_BINDIR=${GAMES_BINDIR:-${GAMES_PREFIX}/bin}

# @ECLASS-VARIABLE: GAMES_ENVD
# @INTERNAL
# @DESCRIPTION:
# The games environment file name which sets games specific LDPATH and PATH.
GAMES_ENVD="90games"

# @ECLASS-VARIABLE: GAMES_USER
# @DESCRIPTION:
# The USER who owns all game files and usually has write permissions.
# May be set by the user.
GAMES_USER=${GAMES_USER:-root}

# @ECLASS-VARIABLE: GAMES_USER_DED
# @DESCRIPTION:
# The USER who owns all game files related to the dedicated server part
# of a package. May be set by the user.
GAMES_USER_DED=${GAMES_USER_DED:-games}

# @ECLASS-VARIABLE: GAMES_GROUP
# @DESCRIPTION:
# The GROUP that owns all game files and usually does not have
# write permissions. May be set by the user.
# If you want games world-executable, then you can at least set this variable
# to 'users' which is almost the same.
GAMES_GROUP=${GAMES_GROUP:-games}

# @FUNCTION: games_get_libdir
# @DESCRIPTION:
# Gets the directory where to install games libraries. This is in LDPATH.
games_get_libdir() {
	echo ${GAMES_PREFIX}/$(get_libdir)
}

# @FUNCTION: egamesconf
# @USAGE: [<args>...]
# @DESCRIPTION:
# Games equivalent to 'econf' for autotools based build systems. It passes
# the necessary games specific directories automatically.
egamesconf() {
	# handle verbose build log pre-EAPI5
	local _gamesconf
	if has "${EAPI:-0}" 0 1 2 3 4 ; then
		if grep -q -s disable-silent-rules "${ECONF_SOURCE:-.}"/configure ; then
			_gamesconf="--disable-silent-rules"
		fi
	fi

	# bug 493954
	if grep -q -s datarootdir "${ECONF_SOURCE:-.}"/configure ; then
		_gamesconf="${_gamesconf} --datarootdir=/usr/share"
	fi

	econf \
		--prefix="${GAMES_PREFIX}" \
		--libdir="$(games_get_libdir)" \
		--datadir="${GAMES_DATADIR}" \
		--sysconfdir="${GAMES_SYSCONFDIR}" \
		--localstatedir="${GAMES_STATEDIR}" \
		${_gamesconf} \
		"$@"
}

# @FUNCTION: gameswrapper
# @USAGE: <command> [<args>...]
# @INTERNAL
# @DESCRIPTION:
# Wraps an install command like dobin, dolib etc, so that
# it has GAMES_PREFIX as prefix.
gameswrapper() {
	# dont want to pollute calling env
	(
		into "${GAMES_PREFIX}"
		cmd=$1
		shift
		${cmd} "$@"
	)
}

# @FUNCTION: dogamesbin
# @USAGE: <path>...
# @DESCRIPTION:
# Install one or more games binaries.
dogamesbin() { gameswrapper ${FUNCNAME/games} "$@"; }

# @FUNCTION: dogamessbin
# @USAGE: <path>...
# @DESCRIPTION:
# Install one or more games system binaries.
dogamessbin() { gameswrapper ${FUNCNAME/games} "$@"; }

# @FUNCTION: dogameslib
# @USAGE: <path>...
# @DESCRIPTION:
# Install one or more games libraries.
dogameslib() { gameswrapper ${FUNCNAME/games} "$@"; }

# @FUNCTION: dogameslib.a
# @USAGE: <path>...
# @DESCRIPTION:
# Install one or more static games libraries.
dogameslib.a() { gameswrapper ${FUNCNAME/games} "$@"; }

# @FUNCTION: dogameslib.so
# @USAGE: <path>...
# @DESCRIPTION:
# Install one or more shared games libraries.
dogameslib.so() { gameswrapper ${FUNCNAME/games} "$@"; }

# @FUNCTION: newgamesbin
# @USAGE: <path> <newname>
# @DESCRIPTION:
# Install one games binary with a new name.
newgamesbin() { gameswrapper ${FUNCNAME/games} "$@"; }

# @FUNCTION: newgamessbin
# @USAGE: <path> <newname>
# @DESCRIPTION:
# Install one system games binary with a new name.
newgamessbin() { gameswrapper ${FUNCNAME/games} "$@"; }

# @FUNCTION: games_make_wrapper
# @USAGE: <wrapper> <target> [chdir] [libpaths] [installpath]
# @DESCRIPTION:
# Create a shell wrapper script named wrapper in installpath
# (defaults to the games bindir) to execute target (default of wrapper) by
# first optionally setting LD_LIBRARY_PATH to the colon-delimited
# libpaths followed by optionally changing directory to chdir.
games_make_wrapper() { gameswrapper ${FUNCNAME/games_} "$@"; }

# @FUNCTION: gamesowners
# @USAGE: [<args excluding owner/group>...] <path>...
# @DESCRIPTION:
# Run 'chown' with the given args on the given files. Owner and
# group are GAMES_USER and GAMES_GROUP and must not be passed
# as args.
gamesowners() { chown ${GAMES_USER}:${GAMES_GROUP} "$@"; }

# @FUNCTION: gamesperms
# @USAGE: <path>...
# @DESCRIPTION:
# Run 'chmod' with games specific permissions on the given files.
gamesperms() { chmod u+rw,g+r-w,o-rwx "$@"; }

# @FUNCTION: prepgamesdirs
# @DESCRIPTION:
# Fix all permissions/owners of files in games related directories,
# usually called at the end of src_install().
prepgamesdirs() {
	local dir f mode
	for dir in \
		"${GAMES_PREFIX}" "${GAMES_PREFIX_OPT}" "${GAMES_DATADIR}" \
		"${GAMES_SYSCONFDIR}" "${GAMES_STATEDIR}" "$(games_get_libdir)" \
		"${GAMES_BINDIR}" "$@"
	do
		[[ ! -d ${D}/${dir} ]] && continue
		(
			gamesowners -R "${D}/${dir}"
			find "${D}/${dir}" -type d -print0 | xargs -0 chmod 750
			mode=o-rwx,g+r,g-w
			[[ ${dir} = ${GAMES_STATEDIR} ]] && mode=o-rwx,g+r
			find "${D}/${dir}" -type f -print0 | xargs -0 chmod $mode

			# common trees should not be games owned #264872 #537580
			fowners root:root "${dir}"
			fperms 755 "${dir}"
			if [[ ${dir} == "${GAMES_PREFIX}" \
						|| ${dir} == "${GAMES_PREFIX_OPT}" ]] ; then
				for d in $(get_libdir) bin ; do
					# check if dirs exist to avoid "nonfatal" option
					if [[ -e ${D}/${dir}/${d} ]] ; then
						fowners root:root "${dir}/${d}"
						fperms 755 "${dir}/${d}"
					fi
				done
			fi
		) &>/dev/null

		f=$(find "${D}/${dir}" -perm +4000 -a -uid 0 2>/dev/null)
		if [[ -n ${f} ]] ; then
			eerror "A game was detected that is setuid root!"
			eerror "${f}"
			die "refusing to merge a setuid root game"
		fi
	done
	[[ -d ${D}/${GAMES_BINDIR} ]] || return 0
	find "${D}/${GAMES_BINDIR}" -maxdepth 1 -type f -exec chmod 750 '{}' \;
}

# @FUNCTION: games_pkg_setup
# @DESCRIPTION:
# Export some toolchain specific variables and create games related groups
# and users. This function is exported as pkg_setup().
games_pkg_setup() {
	tc-export CC CXX LD AR RANLIB

	enewgroup "${GAMES_GROUP}" 35
	[[ ${GAMES_USER} != "root" ]] \
		&& enewuser "${GAMES_USER}" 35 -1 "${GAMES_PREFIX}" "${GAMES_GROUP}"
	[[ ${GAMES_USER_DED} != "root" ]] \
		&& enewuser "${GAMES_USER_DED}" 36 /bin/bash "${GAMES_PREFIX}" "${GAMES_GROUP}"

	# Dear portage team, we are so sorry.  Lots of love, games team.
	# See Bug #61680
	[[ ${USERLAND} != "GNU" ]] && return 0
	[[ $(egetshell "${GAMES_USER_DED}") == "/bin/false" ]] \
		&& usermod -s /bin/bash "${GAMES_USER_DED}"
}

# @FUNCTION: games_src_configure
# @DESCRIPTION:
# Runs egamesconf if there is a configure file.
# This function is exported as src_configure().
games_src_configure() {
	[[ -x "${ECONF_SOURCE:-.}"/configure ]] && egamesconf
}

# @FUNCTION: games_src_compile
# @DESCRIPTION:
# Runs base_src_make(). This function is exported as src_compile().
games_src_compile() {
	case ${EAPI:-0} in
		0|1) games_src_configure ;;
	esac
	base_src_make
}

# @FUNCTION: games_pkg_preinst
# @DESCRIPTION:
# Synchronizes GAMES_STATEDIR of the ebuild image with the live filesystem.
games_pkg_preinst() {
	local f

	while read f ; do
		if [[ -e ${ROOT}/${GAMES_STATEDIR}/${f} ]] ; then
			cp -p \
				"${ROOT}/${GAMES_STATEDIR}/${f}" \
				"${D}/${GAMES_STATEDIR}/${f}" \
				|| die "cp failed"
			# make the date match the rest of the install
			touch "${D}/${GAMES_STATEDIR}/${f}"
		fi
	done < <(find "${D}/${GAMES_STATEDIR}" -type f -printf '%P\n' 2>/dev/null)
}

# @FUNCTION: games_pkg_postinst
# @DESCRIPTION:
# Prints some warnings and infos, also related to games groups.
games_pkg_postinst() {
	if [[ -z "${GAMES_SHOW_WARNING}" ]] ; then
		ewarn "Remember, in order to play games, you have to"
		ewarn "be in the '${GAMES_GROUP}' group."
		echo
		case ${CHOST} in
			*-darwin*) ewarn "Just run 'niutil -appendprop / /groups/games users <USER>'";;
			*-freebsd*|*-dragonfly*) ewarn "Just run 'pw groupmod ${GAMES_GROUP} -m <USER>'";;
			*) ewarn "Just run 'gpasswd -a <USER> ${GAMES_GROUP}', then have <USER> re-login.";;
		esac
		echo
		einfo "For more info about Gentoo gaming in general, see our website:"
		einfo "   http://games.gentoo.org/"
		echo
	fi
}

# @FUNCTION: games_ut_unpack
# @USAGE: <directory or file to unpack>
# @DESCRIPTION:
# Unpack .uz2 files for UT2003/UT2004.
games_ut_unpack() {
	local ut_unpack="$1"
	local f=

	if [[ -z ${ut_unpack} ]] ; then
		die "You must provide an argument to games_ut_unpack"
	fi
	if [[ -f ${ut_unpack} ]] ; then
		uz2unpack "${ut_unpack}" "${ut_unpack%.uz2}" \
			|| die "uncompressing file ${ut_unpack}"
	fi
	if [[ -d ${ut_unpack} ]] ; then
		while read f ; do
			uz2unpack "${ut_unpack}/${f}" "${ut_unpack}/${f%.uz2}" \
				|| die "uncompressing file ${f}"
			rm -f "${ut_unpack}/${f}" || die "deleting compressed file ${f}"
		done < <(find "${ut_unpack}" -maxdepth 1 -name '*.uz2' -printf '%f\n' 2>/dev/null)
	fi
}

# @FUNCTION: games_umod_unpack
# @USAGE: <file to unpack>
# @DESCRIPTION:
# Unpacks .umod/.ut2mod/.ut4mod files for UT/UT2003/UT2004.
# Don't forget to set 'dir' and 'Ddir'.
games_umod_unpack() {
	local umod=$1
	mkdir -p "${Ddir}"/System
	cp "${dir}"/System/{ucc-bin,{Manifest,Def{ault,User}}.ini,{Engine,Core,zlib,ogg,vorbis}.so,{Engine,Core}.int} "${Ddir}"/System
	cd "${Ddir}"/System
	UT_DATA_PATH=${Ddir}/System ./ucc-bin umodunpack -x "${S}/${umod}" -nohomedir &> /dev/null \
		|| die "uncompressing file ${umod}"
	rm -f "${Ddir}"/System/{ucc-bin,{Manifest,Def{ault,User},User,UT200{3,4}}.ini,{Engine,Core,zlib,ogg,vorbis}.so,{Engine,Core}.int,ucc.log} &>/dev/null \
		|| die "Removing temporary files"
}

fi
