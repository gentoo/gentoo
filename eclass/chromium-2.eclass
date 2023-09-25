# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: chromium-2.eclass
# @MAINTAINER:
# Chromium Project <chromium@gentoo.org>
# @AUTHOR:
# Mike Gilbert <floppym@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Shared functions for chromium and google-chrome

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

inherit linux-info

if [[ -z ${_CHROMIUM_2_ECLASS} ]]; then
_CHROMIUM_2_ECLASS=1

if [[ ${PN} == chromium ]]; then
	IUSE+=" custom-cflags"
fi

# @FUNCTION: chromium_suid_sandbox_check_kernel_config
# @USAGE:
# @DESCRIPTION:
# Ensures the system kernel supports features needed for SUID and User namespaces sandbox
# to work.
chromium_suid_sandbox_check_kernel_config() {
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
		ERROR_GRKERNSEC="CONFIG_GRKERNSEC breaks sandbox (bug #613668)"
		CONFIG_CHECK="~PID_NS ~NET_NS ~SECCOMP_FILTER ~USER_NS ~ADVISE_SYSCALLS ~!COMPAT_VDSO ~!GRKERNSEC"
		check_extra_config
	fi
}

# @ECLASS_VARIABLE: CHROMIUM_LANGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# List of language packs available for this package.

# @FUNCTION: _chromium_set_l10n_IUSE
# @USAGE:
# @INTERNAL
# @DESCRIPTION:
# Converts and adds CHROMIUM_LANGS to IUSE. Called automatically if
# CHROMIUM_LANGS is defined.
_chromium_set_l10n_IUSE() {
	local lang
	for lang in ${CHROMIUM_LANGS}; do
		# Default to enabled since we bundle them anyway.
		# USE-expansion will take care of disabling the langs the user has not
		# selected via L10N.
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
# not selected via the L10N variable.
# Also performs QA checks to ensure CHROMIUM_LANGS has been set correctly.
chromium_remove_language_paks() {
	local lang pak

	# Look for missing pak files.
	for lang in ${CHROMIUM_LANGS}; do
		if [[ ! -e ${lang}.pak ]]; then
			eqawarn "L10N warning: no .pak file for ${lang} (${lang}.pak not found)"
		fi
	done

	# Bug 588198
	rm -f fake-bidi.pak || die
	rm -f fake-bidi.pak.info || die

	# Look for extra pak files.
	# Remove pak files that the user does not want.
	for pak in *.pak; do
		lang=${pak%.pak}

		if [[ ${lang} == en-US ]]; then
			continue
		fi

		if ! has ${lang} ${CHROMIUM_LANGS}; then
			eqawarn "L10N warning: no ${lang} in LANGS"
			continue
		fi

		if ! use l10n_${lang}; then
			rm "${pak}" || die
			rm -f "${pak}.info" || die
		fi
	done
}

# @FUNCTION: chromium_pkg_die
# @USAGE:
# @DESCRIPTION:
# EBUILD_DEATH_HOOK function to display some warnings/information about build environment.
chromium_pkg_die() {
	if [[ "${EBUILD_PHASE}" != "compile" ]]; then
		return
	fi

	# Prevent user problems like bug #348235.
	if is-flagq '-g?(gdb)?([1-9])'; then
		ewarn
		ewarn "You have enabled debug info (i.e. -g or -ggdb in your CFLAGS/CXXFLAGS)."
		ewarn "This produces very large build files causes the linker to consume large"
		ewarn "amounts of memory."
		ewarn
		ewarn "Please try removing -g{,gdb} before reporting a bug."
		ewarn
	fi

	# ccache often causes bogus compile failures, especially when the cache gets
	# corrupted.
	if has ccache ${FEATURES}; then
		ewarn
		ewarn "You have enabled ccache. Please try disabling ccache"
		ewarn "before reporting a bug."
		ewarn
	fi

	# No ricer bugs.
	if in_iuse custom-cflags && use custom-cflags; then
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

fi
