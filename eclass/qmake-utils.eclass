# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: qmake-utils.eclass
# @MAINTAINER:
# Qt herd <qt@gentoo.org>
# @AUTHOR:
# Davide Pesavento <pesa@gentoo.org>
# @BLURB: Common functions for qmake-based packages.
# @DESCRIPTION:
# Utility eclass providing wrapper functions for Qt4 and Qt5 qmake.
#
# This eclass does not set any metadata variables nor export any phase
# functions. It can be inherited safely.

if [[ -z ${_QMAKE_UTILS_ECLASS} ]]; then
_QMAKE_UTILS_ECLASS=1

[[ ${EAPI:-0} == [012345] ]] && inherit multilib
inherit eutils toolchain-funcs

# @FUNCTION: qt4_get_bindir
# @DESCRIPTION:
# Echoes the directory where Qt4 binaries are installed.
# EPREFIX is already prepended to the returned path.
qt4_get_bindir() {
	has "${EAPI:-0}" 0 1 2 && use !prefix && EPREFIX=

	local qtbindir=${EPREFIX}$(qt4_get_libdir)/bin
	if [[ -d ${qtbindir} ]]; then
		echo ${qtbindir}
	else
		echo ${EPREFIX}/usr/bin
	fi
}

# @FUNCTION: qt4_get_headerdir
# @DESCRIPTION:
# Echoes the directory where Qt4 headers are installed.
qt4_get_headerdir() {
	echo /usr/include/qt4
}

# @FUNCTION: qt4_get_libdir
# @DESCRIPTION:
# Echoes the directory where Qt4 libraries are installed.
qt4_get_libdir() {
	echo /usr/$(get_libdir)/qt4
}

# @FUNCTION: qt4_get_mkspecsdir
# @DESCRIPTION:
# Echoes the directory where Qt4 mkspecs are installed.
qt4_get_mkspecsdir() {
	echo /usr/share/qt4/mkspecs
}

# @FUNCTION: qt4_get_plugindir
# @DESCRIPTION:
# Echoes the directory where Qt4 plugins are installed.
qt4_get_plugindir() {
	echo $(qt4_get_libdir)/plugins
}

# @FUNCTION: qt5_get_bindir
# @DESCRIPTION:
# Echoes the directory where Qt5 binaries are installed.
# EPREFIX is already prepended to the returned path.
qt5_get_bindir() {
	has "${EAPI:-0}" 0 1 2 && use !prefix && EPREFIX=

	echo ${EPREFIX}$(qt5_get_libdir)/qt5/bin
}

# @FUNCTION: qt5_get_headerdir
# @DESCRIPTION:
# Echoes the directory where Qt5 headers are installed.
qt5_get_headerdir() {
	echo /usr/include/qt5
}

# @FUNCTION: qt5_get_libdir
# @DESCRIPTION:
# Echoes the directory where Qt5 libraries are installed.
qt5_get_libdir() {
	echo /usr/$(get_libdir)
}

# @FUNCTION: qt5_get_mkspecsdir
# @DESCRIPTION:
# Echoes the directory where Qt5 mkspecs are installed.
qt5_get_mkspecsdir() {
	echo $(qt5_get_libdir)/qt5/mkspecs
}

# @FUNCTION: qt5_get_plugindir
# @DESCRIPTION:
# Echoes the directory where Qt5 plugins are installed.
qt5_get_plugindir() {
	echo $(qt5_get_libdir)/qt5/plugins
}

# @FUNCTION: qmake-utils_find_pro_file
# @RETURN: zero or one qmake .pro file names
# @INTERNAL
# @DESCRIPTION:
# Outputs a project file name that can be passed to eqmake.
#   0 *.pro files found --> outputs null string;
#   1 *.pro file found --> outputs its name;
#   2 or more *.pro files found --> if "${PN}.pro" or
#       "$(basename ${S}).pro" are there, outputs one of them.
qmake-utils_find_pro_file() {
	local dir_name=$(basename "${S}")

	# set nullglob to avoid expanding *.pro to the literal
	# string "*.pro" when there are no matching files
	eshopts_push -s nullglob
	local pro_files=(*.pro)
	eshopts_pop

	case ${#pro_files[@]} in
	0)
		: ;;
	1)
		echo "${pro_files}"
		;;
	*)
		for pro_file in "${pro_files[@]}"; do
			if [[ ${pro_file%.pro} == ${dir_name} || ${pro_file%.pro} == ${PN} ]]; then
				echo "${pro_file}"
				break
			fi
		done
		;;
	esac
}

# @VARIABLE: EQMAKE4_EXCLUDE
# @DEFAULT_UNSET
# @DESCRIPTION:
# List of files to be excluded from eqmake4 CONFIG processing.
# Paths are relative to the current working directory (usually ${S}).
#
# Example: EQMAKE4_EXCLUDE="ignore/me.pro foo/*"

# @FUNCTION: eqmake4
# @USAGE: [project_file] [parameters to qmake]
# @DESCRIPTION:
# Wrapper for Qt4's qmake. If project_file is not specified, eqmake4 looks
# for one in the current directory (non-recursively). If multiple project
# files are found, then ${PN}.pro is used, if it exists, otherwise eqmake4
# will not be able to continue.
#
# All other arguments are appended unmodified to qmake command line.
#
# For recursive build systems, i.e. those based on the subdirs template,
# you should run eqmake4 on the top-level project file only, unless you
# have a valid reason to do otherwise. During the building, qmake will
# be automatically re-invoked with the right arguments on every directory
# specified inside the top-level project file.
eqmake4() {
	debug-print-function ${FUNCNAME} "$@"

	has "${EAPI:-0}" 0 1 2 && use !prefix && EPREFIX=

	ebegin "Running qmake"

	local qmake_args=("$@")

	# Check if the project file name was passed as first argument. If not, look for candidates.
	local regexp='.*\.pro'
	if ! [[ ${1} =~ ${regexp} ]]; then
		local project_file=$(qmake-utils_find_pro_file)
		if [[ -z ${project_file} ]]; then
			echo
			eerror "No project files found in '${PWD}'"
			eerror "This shouldn't happen - please send a bug report to https://bugs.gentoo.org/"
			echo
			die "eqmake4 failed"
		fi
		qmake_args+=("${project_file}")
	fi

	# Make sure the CONFIG variable is correctly set for both release and debug builds.
	local config_add=release
	local config_remove=debug
	if use_if_iuse debug; then
		config_add=debug
		config_remove=release
	fi

	local awkscript='BEGIN {
				printf "### eqmake4 was here ###\n" > file;
				printf "CONFIG -= debug_and_release %s\n", remove >> file;
				printf "CONFIG += %s\n\n", add >> file;
				fixed=0;
			}
			/^[[:blank:]]*CONFIG[[:blank:]]*[\+\*]?=/ {
				if (gsub("\\<((" remove ")|(debug_and_release))\\>", "") > 0) {
					fixed=1;
				}
			}
			/^[[:blank:]]*CONFIG[[:blank:]]*-=/ {
				if (gsub("\\<" add "\\>", "") > 0) {
					fixed=1;
				}
			}
			{
				print >> file;
			}
			END {
				print fixed;
			}'

	[[ -n ${EQMAKE4_EXCLUDE} ]] && eshopts_push -o noglob

	local file
	while read file; do
		local excl
		for excl in ${EQMAKE4_EXCLUDE}; do
			[[ ${file} == ${excl} ]] && continue 2
		done
		grep -q '^### eqmake4 was here ###$' "${file}" && continue

		local retval=$({
			rm -f "${file}" || echo FAIL
			awk -v file="${file}" \
				-v add=${config_add} \
				-v remove=${config_remove} \
				-- "${awkscript}" || echo FAIL
			} < "${file}")

		if [[ ${retval} == 1 ]]; then
			einfo " - fixed CONFIG in ${file}"
		elif [[ ${retval} != 0 ]]; then
			eerror " - error while processing ${file}"
			die "eqmake4 failed to process ${file}"
		fi
	done < <(find . -type f -name '*.pr[io]' -printf '%P\n' 2>/dev/null)

	[[ -n ${EQMAKE4_EXCLUDE} ]] && eshopts_pop

	"$(qt4_get_bindir)"/qmake \
		-makefile \
		QMAKE_AR="$(tc-getAR) cqs" \
		QMAKE_CC="$(tc-getCC)" \
		QMAKE_CXX="$(tc-getCXX)" \
		QMAKE_LINK="$(tc-getCXX)" \
		QMAKE_LINK_C="$(tc-getCC)" \
		QMAKE_OBJCOPY="$(tc-getOBJCOPY)" \
		QMAKE_RANLIB= \
		QMAKE_STRIP= \
		QMAKE_CFLAGS="${CFLAGS}" \
		QMAKE_CFLAGS_RELEASE= \
		QMAKE_CFLAGS_DEBUG= \
		QMAKE_CXXFLAGS="${CXXFLAGS}" \
		QMAKE_CXXFLAGS_RELEASE= \
		QMAKE_CXXFLAGS_DEBUG= \
		QMAKE_LFLAGS="${LDFLAGS}" \
		QMAKE_LFLAGS_RELEASE= \
		QMAKE_LFLAGS_DEBUG= \
		QMAKE_LIBDIR_QT="${EPREFIX}$(qt4_get_libdir)" \
		QMAKE_LIBDIR_X11="${EPREFIX}/usr/$(get_libdir)" \
		QMAKE_LIBDIR_OPENGL="${EPREFIX}/usr/$(get_libdir)" \
		"${qmake_args[@]}"

	if ! eend $? ; then
		echo
		eerror "Running qmake has failed! (see above for details)"
		eerror "This shouldn't happen - please send a bug report to https://bugs.gentoo.org/"
		echo
		die "eqmake4 failed"
	fi
}

# @FUNCTION: eqmake5
# @USAGE: [arguments for qmake]
# @DESCRIPTION:
# Wrapper for Qt5's qmake. All arguments are passed to qmake.
#
# For recursive build systems, i.e. those based on the subdirs template,
# you should run eqmake5 on the top-level project file only, unless you
# have a valid reason to do otherwise. During the building, qmake will
# be automatically re-invoked with the right arguments on every directory
# specified inside the top-level project file.
eqmake5() {
	debug-print-function ${FUNCNAME} "$@"

	ebegin "Running qmake"

	"$(qt5_get_bindir)"/qmake \
		-makefile \
		QMAKE_AR="$(tc-getAR) cqs" \
		QMAKE_CC="$(tc-getCC)" \
		QMAKE_LINK_C="$(tc-getCC)" \
		QMAKE_LINK_C_SHLIB="$(tc-getCC)" \
		QMAKE_CXX="$(tc-getCXX)" \
		QMAKE_LINK="$(tc-getCXX)" \
		QMAKE_LINK_SHLIB="$(tc-getCXX)" \
		QMAKE_OBJCOPY="$(tc-getOBJCOPY)" \
		QMAKE_RANLIB= \
		QMAKE_STRIP= \
		QMAKE_CFLAGS="${CFLAGS}" \
		QMAKE_CFLAGS_RELEASE= \
		QMAKE_CFLAGS_DEBUG= \
		QMAKE_CXXFLAGS="${CXXFLAGS}" \
		QMAKE_CXXFLAGS_RELEASE= \
		QMAKE_CXXFLAGS_DEBUG= \
		QMAKE_LFLAGS="${LDFLAGS}" \
		QMAKE_LFLAGS_RELEASE= \
		QMAKE_LFLAGS_DEBUG= \
		"$@"

	if ! eend $? ; then
		echo
		eerror "Running qmake has failed! (see above for details)"
		eerror "This shouldn't happen - please send a bug report to https://bugs.gentoo.org/"
		echo
		die "eqmake5 failed"
	fi
}

fi
