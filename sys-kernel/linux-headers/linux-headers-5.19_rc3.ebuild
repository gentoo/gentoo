# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ETYPE="headers"
H_SUPPORTEDARCH="alpha amd64 arc arm arm64 avr32 cris frv hexagon hppa ia64 loong m68k metag microblaze mips mn10300 nios2 openrisc ppc ppc64 riscv s390 score sh sparc x86 xtensa"
# The v5.19 rc patches generated on kernel.org contain a suppressed binary file diff,
# hence unusable. Here we only let kernel-2 handle the base 5.18 tarball; the
# v5.19 rc patch is to be handled later.
K_BASE_VER="5.18"
CKV="${K_BASE_VER}"
inherit kernel-2
detect_version

#PATCH_PV=${PV} # to ease testing new versions against not existing patches
PATCH_PV="${K_BASE_VER}"
PATCH_VER="1"
PATCH_DEV="sam"
SRC_URI="${KERNEL_URI}
	${PATCH_VER:+https://dev.gentoo.org/~${PATCH_DEV}/distfiles/sys-kernel/linux-headers/gentoo-headers-${PATCH_PV}-${PATCH_VER}.tar.xz}
	https://dev.gentoo.org/~xen0n/distfiles/sys-kernel/linux-headers/${P}-only-arch-and-headers.patch.xz"
S="${WORKDIR}/linux-${K_BASE_VER}"

# this is an rc version, for testing on loong only
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
KEYWORDS="~loong"

BDEPEND="app-arch/xz-utils
	dev-lang/perl"

# bug #816762
RESTRICT="test"

[[ -n ${PATCH_VER} ]] && PATCHES=( "${WORKDIR}"/${PATCH_PV} )

src_unpack() {
	# avoid kernel-2_src_unpack
	default
}

src_prepare() {
	# apply the gentoo-headers patches after the big v5.19 rc patch, for
	# avoiding flooding the console because of the lirc change
	PATCHES=(
		"${WORKDIR}/${P}-only-arch-and-headers.patch"
		"${PATCHES[@]}"
	)

	# TODO: May need forward porting to newer versions
	use elibc_musl && PATCHES+=(
		"${FILESDIR}"/${PN}-5.10-Use-stddefs.h-instead-of-compiler.h.patch
		"${FILESDIR}"/${PN}-5.15-remove-inclusion-sysinfo.h.patch
	)

	# avoid kernel-2_src_prepare
	default
}

src_test() {
	emake headers_check ${xmakeopts}
}

src_install() {
	kernel-2_src_install

	find "${ED}" \( -name '.install' -o -name '*.cmd' \) -delete || die
	# delete empty directories
	find "${ED}" -empty -type d -delete || die
}
