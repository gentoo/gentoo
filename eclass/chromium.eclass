# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: chromium.eclass
# @MAINTAINER:
# Chromium Herd <chromium@gentoo.org>
# @AUTHOR:
# Mike Gilbert <floppym@gentoo.org>
# @BLURB: Shared functions for chromium and google-chrome

inherit eutils fdo-mime gnome2-utils linux-info

if [[ ${CHROMIUM_EXPORT_PHASES} != no ]]; then
	EXPORT_FUNCTIONS pkg_preinst pkg_postinst pkg_postrm
fi

if [[ ${PN} == chromium ]]; then
	IUSE+=" custom-cflags"
fi

# @FUNCTION: chromium_suid_sandbox_check_kernel_config
# @USAGE:
# @DESCRIPTION:
# Ensures the system kernel supports features needed for SUID sandbox to work.
chromium_suid_sandbox_check_kernel_config() {
	has "${EAPI:-0}" 0 1 2 3 && die "EAPI=${EAPI} is not supported"

	if [[ "${MERGE_TYPE}" == "source" || "${MERGE_TYPE}" == "binary" ]]; then
		# Warn if the kernel does not support features needed for sandboxing.
		# Bug #363987.
		ERROR_PID_NS="PID_NS is required for sandbox to work"
		ERROR_NET_NS="NET_NS is required for sandbox to work"
		ERROR_USER_NS="USER_NS is required for sandbox to work"
		ERROR_SECCOMP_FILTER="SECCOMP_FILTER is required for sandbox to work"
		CONFIG_CHECK="~PID_NS ~NET_NS ~SECCOMP_FILTER ~USER_NS"
		check_extra_config
	fi
}

# @ECLASS-VARIABLE: CHROMIUM_LANGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# List of language packs available for this package.

_chromium_set_linguas_IUSE() {
	[[ ${EAPI:-0} == 0 ]] && die "EAPI=${EAPI} is not supported"

	local lang
	for lang in ${CHROMIUM_LANGS}; do
		# Default to enabled since we bundle them anyway.
		# USE-expansion will take care of disabling the langs the user has not
		# selected via LINGUAS.
		IUSE+=" +linguas_${lang}"
	done
}

if [[ ${CHROMIUM_LANGS} ]]; then
	_chromium_set_linguas_IUSE
fi

_chromium_crlang() {
	local x
	for x in "$@"; do
		case $x in
			es_LA) echo es-419 ;;
			*) echo "${x/_/-}" ;;
		esac
	done
}

_chromium_syslang() {
	local x
	for x in "$@"; do
		case $x in
			es-419) echo es_LA ;;
			*) echo "${x/-/_}" ;;
		esac
	done
}

_chromium_strip_pak() {
	local x
	for x in "$@"; do
		echo "${x%.pak}"
	done
}

# @FUNCTION: chromium_remove_language_paks
# @USAGE:
# @DESCRIPTION:
# Removes pak files from the current directory for languages that the user has
# not selected via the LINGUAS variable.
# Also performs QA checks to ensure CHROMIUM_LANGS has been set correctly.
chromium_remove_language_paks() {
	local crlangs=$(_chromium_crlang ${CHROMIUM_LANGS})
	local present_crlangs=$(_chromium_strip_pak *.pak)
	local present_langs=$(_chromium_syslang ${present_crlangs})
	local lang

	# Look for missing pak files.
	for lang in ${crlangs}; do
		if ! has ${lang} ${present_crlangs}; then
			eqawarn "LINGUAS warning: no .pak file for ${lang} (${lang}.pak not found)"
		fi
	done

	# Look for extra pak files.
	# Remove pak files that the user does not want.
	for lang in ${present_langs}; do
		if [[ ${lang} == en_US ]]; then
			continue
		fi
		if ! has ${lang} ${CHROMIUM_LANGS}; then
			eqawarn "LINGUAS warning: no ${lang} in LANGS"
			continue
		fi
		if ! use linguas_${lang}; then
			rm "$(_chromium_crlang ${lang}).pak" || die
		fi
	done
}

chromium_pkg_preinst() {
	gnome2_icon_savelist
}

chromium_pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update

	# For more info see bug #292201, bug #352263, bug #361859.
	if ! has_version x11-themes/gnome-icon-theme &&
		! has_version x11-themes/oxygen-icons ; then
		elog
		elog "Depending on your desktop environment, you may need"
		elog "to install additional packages to get icons on the Downloads page."
		elog
		elog "For KDE, the required package is kde-apps/oxygen-icons."
		elog
		elog "For other desktop environments, try one of the following:"
		elog " - x11-themes/gnome-icon-theme"
		elog " - x11-themes/tango-icon-theme"
	fi

	# For more info see bug #359153.
	elog
	elog "Some web pages may require additional fonts to display properly."
	elog "Try installing some of the following packages if some characters"
	elog "are not displayed properly:"
	elog " - media-fonts/arphicfonts"
	elog " - media-fonts/bitstream-cyberbit"
	elog " - media-fonts/droid"
	elog " - media-fonts/ipamonafont"
	elog " - media-fonts/ja-ipafonts"
	elog " - media-fonts/takao-fonts"
	elog " - media-fonts/wqy-microhei"
	elog " - media-fonts/wqy-zenhei"
}

chromium_pkg_postrm() {
	gnome2_icon_cache_update
}

chromium_pkg_die() {
	if [[ "${EBUILD_PHASE}" != "compile" ]]; then
		return
	fi

	# Prevent user problems like bug #348235.
	eshopts_push -s extglob
	if is-flagq '-g?(gdb)?([1-9])'; then
		ewarn
		ewarn "You have enabled debug info (i.e. -g or -ggdb in your CFLAGS/CXXFLAGS)."
		ewarn "This produces very large build files causes the linker to consume large"
		ewarn "amounts of memory."
		ewarn
		ewarn "Please try removing -g{,gdb} before reporting a bug."
		ewarn
	fi
	eshopts_pop

	# ccache often causes bogus compile failures, especially when the cache gets
	# corrupted.
	if has ccache ${FEATURES}; then
		ewarn
		ewarn "You have enabled ccache. Please try disabling ccache"
		ewarn "before reporting a bug."
		ewarn
	fi

	# No ricer bugs.
	if use_if_iuse custom-cflags; then
		ewarn
		ewarn "You have enabled the custom-cflags USE flag."
		ewarn "Please disable it before reporting a bug."
		ewarn
	fi

	# If the system doesn't have enough memory, the compilation is known to
	# fail. Print info about memory to recognize this condition.
	einfo
	einfo "$(grep MemTotal /proc/meminfo)"
	einfo "$(grep SwapTotal /proc/meminfo)"
	einfo
}

# @VARIABLE: EGYP_CHROMIUM_COMMAND
# @DESCRIPTION:
# Path to the gyp_chromium script.
: ${EGYP_CHROMIUM_COMMAND:=build/gyp_chromium}

# @VARIABLE: EGYP_CHROMIUM_DEPTH
# @DESCRIPTION:
# Depth for egyp_chromium.
: ${EGYP_CHROMIUM_DEPTH:=.}

# @FUNCTION: egyp_chromium
# @USAGE: [gyp arguments]
# @DESCRIPTION:
# Calls EGYP_CHROMIUM_COMMAND with depth EGYP_CHROMIUM_DEPTH and given
# arguments. The full command line is echoed for logging.
egyp_chromium() {
	set -- "${EGYP_CHROMIUM_COMMAND}" --depth="${EGYP_CHROMIUM_DEPTH}" "$@"
	echo "$@"
	"$@"
}

# @FUNCTION: gyp_use
# @USAGE: <USE flag> [GYP flag] [true suffix] [false suffix]
# @DESCRIPTION:
# If USE flag is set, echo -D[GYP flag]=[true suffix].
#
# If USE flag is not set, echo -D[GYP flag]=[false suffix].
#
# [GYP flag] defaults to use_[USE flag] with hyphens converted to underscores.
#
# [true suffix] defaults to 1. [false suffix] defaults to 0.
gyp_use() {
	local gypflag="-D${2:-use_${1//-/_}}="
	usex "$1" "${gypflag}" "${gypflag}"  "${3-1}" "${4-0}"
}

# @FUNCTION: chromium_bundled_v8_version
# @USAGE: [path to version.cc]
# @DESCRIPTION:
# Outputs the version of v8 parsed from a (bundled) copy of the source code.
chromium_bundled_v8_version() {
	local vf=${1:-v8/src/version.cc}
	local major minor build patch
	major=$(sed -ne 's/#define MAJOR_VERSION *\([0-9]*\)/\1/p' "${vf}")
	minor=$(sed -ne 's/#define MINOR_VERSION *\([0-9]*\)/\1/p' "${vf}")
	build=$(sed -ne 's/#define BUILD_NUMBER *\([0-9]*\)/\1/p' "${vf}")
	patch=$(sed -ne 's/#define PATCH_LEVEL *\([0-9]*\)/\1/p' "${vf}")
	echo "${major}.${minor}.${build}.${patch}"
}

# @FUNCTION: chromium_installed_v8_version
# @USAGE:
# @DESCRIPTION:
# Outputs the version of dev-lang/v8 currently installed on the host system.
chromium_installed_v8_version() {
	local cpf=$(best_version dev-lang/v8)
	local pvr=${cpf#dev-lang/v8-}
	echo "${pvr%-r*}"
}
