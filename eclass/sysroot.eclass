# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: sysroot.eclass
# @MAINTAINER:
# cross@gentoo.org
# @AUTHOR:
# James Le Cuirot <chewi@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Common functions for using a different (sys)root
# @DESCRIPTION:
# This eclass provides common functions to run executables within a different
# root or sysroot, with or without emulation by QEMU. Despite the name, these
# functions can be used in src_* or pkg_* phase functions.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @FUNCTION: qemu_arch
# @DESCRIPTION:
# Return the QEMU architecture name for the given target or CHOST. This name is
# used in qemu-user binary filenames, e.g. qemu-ppc64le.
qemu_arch() {
	local target=${1:-${CHOST}}
	case ${target} in
		armeb*) echo armeb ;;
		arm*) echo arm ;;
		hppa*) echo hppa ;;
		i?86*) echo i386 ;;
		m68*) echo m68k ;;
		mips64el*-gnuabi64) echo mips64el ;;
		mips64el*-gnuabin32) echo mipsn32el ;;
		mips64*-gnuabi64) echo mips64 ;;
		mips64*-gnuabin32) echo mipsn32 ;;
		powerpc64le*) echo ppc64le ;;
		powerpc64*) echo ppc64 ;;
		powerpc*) echo ppc ;;
		*) echo "${target%%-*}" ;;
	esac
}

# @FUNCTION: sysroot_make_run_prefixed
# @DESCRIPTION:
# Create a wrapper script for directly running executables within a (sys)root
# without changing the root directory. The path to that script is returned. If
# no sysroot has been set, then this function returns unsuccessfully.
#
# The script explicitly uses QEMU if this is necessary and it is available in
# this environment. It may otherwise implicitly use a QEMU outside this
# environment if binfmt_misc has been used with the F flag. It is not feasible
# to add a conditional dependency on QEMU.
sysroot_make_run_prefixed() {
	local QEMU_ARCH=$(qemu_arch) SCRIPT MYROOT MYEROOT LIBGCC

	if [[ ${EBUILD_PHASE_FUNC} == src_* ]]; then
		[[ -z ${SYSROOT} ]] && return 1
		SCRIPT="${T}"/sysroot-run-prefixed
		MYROOT=${SYSROOT}
		MYEROOT=${ESYSROOT}

		# Both methods below might need help to find GCC's libs. GCC might not
		# be installed in the SYSROOT. Note that Clang supports this flag too.
		LIBGCC=$($(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} -print-libgcc-file-name)
		LIBGCC=${LIBGCC%/*}
	else
		[[ -z ${ROOT} ]] && return 1
		SCRIPT="${T}"/root-run-prefixed
		MYROOT=${ROOT}
		MYEROOT=${EROOT}

		# Both methods below might need help to find GCC's libs. libc++ systems
		# won't have this file, but it's not needed in that case.
		if [[ -f ${EROOT}/etc/ld.so.conf.d/05gcc-${CHOST}.conf ]]; then
			local LIBGCC_A
			mapfile -t LIBGCC_A < "${EROOT}/etc/ld.so.conf.d/05gcc-${CHOST}.conf"
			LIBGCC=$(printf "%s:" "${LIBGCC_A[@]/#/${ROOT}}")
			LIBGCC=${LIBGCC%:}
		fi
	fi

	if [[ ${CHOST} = *-mingw32 ]]; then
		if ! type -P wine >/dev/null; then
			einfo "Wine not found. Continuing without ${SCRIPT##*/} wrapper."
			return 1
		fi

		# UNIX paths can work, but programs will not expect this in %PATH%.
		local winepath="Z:${LIBGCC};Z:${MYEROOT}/bin;Z:${MYEROOT}/usr/bin;Z:${MYEROOT}/$(get_libdir);Z:${MYEROOT}/usr/$(get_libdir)"

		# Assume that Wine can do its own CPU emulation.
		install -m0755 /dev/stdin "${SCRIPT}" <<-EOF || die
			#!/bin/sh
			SANDBOX_ON=0 LD_PRELOAD= WINEPATH="\${WINEPATH}\${WINEPATH+;};${winepath//\//\\}" exec wine "\${@}"
		EOF
	elif [[ ${QEMU_ARCH} == $(qemu_arch "${CBUILD}") ]]; then
		# glibc: ld.so is a symlink, ldd is a binary.
		# musl: ld.so doesn't exist, ldd is a symlink.
		local DLINKER candidate
		for candidate in "${MYEROOT}"/usr/bin/{ld.so,ldd}; do
			if [[ -L ${candidate} ]]; then
				DLINKER=${candidate}
				break
			fi
		done
		[[ -n ${DLINKER} ]] || die "failed to find dynamic linker"

		# musl symlinks ldd to ld-musl.so to libc.so. We want the ld-musl.so
		# path, not the libc.so path, so don't resolve the symlinks entirely.
		DLINKER=$(readlink -ev "${DLINKER}" || die "failed to find dynamic linker")

		# Using LD_LIBRARY_PATH to set the prefix is not perfect, as it doesn't
		# adjust RUNPATHs, but it is probably good enough.
		install -m0755 /dev/stdin "${SCRIPT}" <<-EOF || die
			#!/bin/sh
			LD_LIBRARY_PATH="\${LD_LIBRARY_PATH}\${LD_LIBRARY_PATH+:}${LIBGCC}:${MYEROOT}/$(get_libdir):${MYEROOT}/usr/$(get_libdir)" exec "${DLINKER}" "\${@}"
		EOF
	else
		# Use QEMU's environment variables rather than its command line
		# arguments to cover both explicit and implicit QEMU usage.
		install -m0755 /dev/stdin "${SCRIPT}" <<-EOF || die
			#!/bin/sh
			QEMU_SET_ENV="\${QEMU_SET_ENV}\${QEMU_SET_ENV+,}LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}\${LD_LIBRARY_PATH+:}${LIBGCC}" QEMU_LD_PREFIX="${MYROOT}" exec $(type -P "qemu-${QEMU_ARCH}") "\${@}"
		EOF

		# Meson will fail if the given exe_wrapper does not work, regardless of
		# whether one is actually needed. This is bad if QEMU is not installed
		# and worse if QEMU does not support the architecture. We therefore need
		# to perform our own test up front.
		local test="${SCRIPT}-test"
		echo 'int main(void) { return 0; }' > "${test}.c" || die "failed to write ${test##*/}"
		$(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} "${test}.c" -o "${test}" || die "failed to build ${test##*/}"

		if ! "${SCRIPT}" "${test}" &>/dev/null; then
			einfo "Failed to run ${test##*/}. Continuing without ${SCRIPT##*/} wrapper."
			return 1
		fi
	fi

	echo "${SCRIPT}"
}

# @FUNCTION: sysroot_run_prefixed
# @DESCRIPTION:
# Create a wrapper script with sysroot_make_run_prefixed if necessary, and use
# it to execute the given command, otherwise just execute the command directly.
sysroot_run_prefixed() {
	local script
	if script=$(sysroot_make_run_prefixed); then
		"${script}" "${@}"
	else
		"${@}"
	fi
}
