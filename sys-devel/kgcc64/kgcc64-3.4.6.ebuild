# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

case ${CHOST} in
	hppa*)    CTARGET=hppa64-${CHOST#*-};;
	mips*)    CTARGET=${CHOST/mips/mips64};;
	powerpc*) CTARGET=${CHOST/powerpc/powerpc64};;
	s390*)    CTARGET=${CHOST/s390/s390x};;
	sparc*)   CTARGET=${CHOST/sparc/sparc64};;
	i?86*)    CTARGET=x86_64-${CHOST#*-};;
esac
export CTARGET
TOOLCHAIN_ALLOWED_LANGS="c"
GCC_TARGET_NO_MULTILIB=true

PATCH_VER="1.2"
GCC_FILESDIR=${FILESDIR/${PN}/gcc}

inherit eutils toolchain

DESCRIPTION="64bit kernel compiler"

KEYWORDS="-* ~hppa ~mips ~ppc ~s390 sparc"

# unlike every other target, hppa has not unified the 32/64 bit
# ports in binutils yet
DEPEND="hppa? ( sys-devel/binutils-hppa64 )
	!sys-devel/gcc-hppa64
	!sys-devel/gcc-mips64
	!sys-devel/gcc-powerpc64
	!sys-devel/gcc-sparc64"

src_prepare() {
	toolchain_src_prepare
	epatch "${GCC_FILESDIR}"/3.4.4/gcc-3.4.4-cross-compile.patch

	# Arch stuff
	case $(tc-arch) in
		mips)
			# Patch forward-ported from a gcc-3.0.x patch that adds -march=r10000 and
			# -mtune=r10000 support to gcc (Allows the compiler to generate code to
			# take advantage of R10k's second ALU, perform shifts, etc..
			epatch "${GCC_FILESDIR}"/3.4.2/gcc-3.4.x-mips-add-march-r10k.patch

			# This is a very special patch -- it allows us to build kernels on SGI IP28
			# (Indigo2 Impact R10000) systems.
			# Unless you're building an IP28 kernel, you really don't need care about what
			# this patch does, because if you are, you are probably already aware of what
			# it does.
			# All that said, the abilities of this patch are disabled by default and need
			# to be enabled by passing -mr10k-cache-barrier.
			# The option also accepts a flag, which are highlighted below:
			#	-mr10k-cache-barrier=1 - Protect stores only (IP28)
			#	-mr10k-cache-barrier=2 - Protect stores and loads (IP32 R10K)
			epatch "${GCC_FILESDIR}"/3.4.2/gcc-3.4.2-mips-ip28_cache_barriers-v4.patch
			;;
	esac
}

pkg_postinst() {
	cd "${ROOT}"/usr/bin
	local x
	for x in gcc cpp ; do
		cat <<-EOF >${CTARGET%%-*}-linux-${x}
		#!/bin/sh
		exec ${CTARGET}-${x} "\$@"
		EOF
		chmod a+rx ${CTARGET%%-*}-linux-${x}
	done
}
