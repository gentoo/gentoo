# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: chromium-2.eclass
# @MAINTAINER:
# Chromium Herd <chromium@gentoo.org>
# @AUTHOR:
# Mike Gilbert <floppym@gentoo.org>
# @BLURB: Shared functions for chromium and google-chrome

inherit eutils linux-info

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
		# Warn if the kernel does not support features needed for the browser to work
		# (bug #552576, bug #556286).
		ERROR_ADVISE_SYSCALLS="CONFIG_ADVISE_SYSCALLS is required for the renderer (bug #552576)"
		ERROR_COMPAT_VDSO="CONFIG_COMPAT_VDSO causes segfaults (bug #556286)"
		CONFIG_CHECK="~PID_NS ~NET_NS ~SECCOMP_FILTER ~USER_NS ~ADVISE_SYSCALLS ~!COMPAT_VDSO"
		check_extra_config
	fi
}

# @ECLASS-VARIABLE: CHROMIUM_LANGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# List of language packs available for this package.

_chromium_set_l10n_IUSE() {
	[[ ${EAPI:-0} == 0 ]] && die "EAPI=${EAPI} is not supported"

	local lang
	for lang in ${CHROMIUM_LANGS}; do
		# Default to enabled since we bundle them anyway.
		# USE-expansion will take care of disabling the langs the user has not
		# selected via LINGUAS.
		IUSE+=" +l10n_${lang}"
	done
}

if [[ ${CHROMIUM_LANGS} ]]; then
	_chromium_set_l10n_IUSE
fi

# @FUNCTION: chromium_remove_language_paks
# @USAGE:
# @DESCRIPTION:
# Removes pak files from the current directory for languages that the user has
# not selected via the LINGUAS variable.
# Also performs QA checks to ensure CHROMIUM_LANGS has been set correctly.
chromium_remove_language_paks() {
	local lang pak

	# Look for missing pak files.
	for lang in ${CHROMIUM_LANGS}; do
		if [[ ! -e ${lang}.pak ]]; then
			eqawarn "LINGUAS warning: no .pak file for ${lang} (${lang}.pak not found)"
		fi
	done

	# Bug 588198
	rm -f fake-bidi.pak || die

	# Look for extra pak files.
	# Remove pak files that the user does not want.
	for pak in *.pak; do
		lang=${pak%.pak}

		if [[ ${lang} == en-US ]]; then
			continue
		fi
		if ! has ${lang} ${CHROMIUM_LANGS}; then
			eqawarn "LINGUAS warning: no ${lang} in LANGS"
			continue
		fi
		if ! use l10n_${lang}; then
			rm "${pak}" || die
		fi
	done
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
