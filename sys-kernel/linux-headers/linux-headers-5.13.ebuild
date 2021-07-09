# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ETYPE="headers"
H_SUPPORTEDARCH="alpha amd64 arc arm arm64 avr32 cris frv hexagon hppa ia64 m68k metag microblaze mips mn10300 nios2 openrisc ppc ppc64 riscv s390 score sh sparc x86 xtensa"
inherit kernel-2 toolchain-funcs
detect_version

PATCH_PV=${PV} # to ease testing new versions against not existing patches
PATCH_VER="1"
SRC_URI="
	${KERNEL_URI}
	${PATCH_VER:+https://dev.gentoo.org/~soap/distfiles/gentoo-headers-${PATCH_PV}-${PATCH_VER}.tar.xz}"
S="${WORKDIR}/linux-${PV}"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

BDEPEND="
	app-arch/xz-utils
	dev-lang/perl"

[[ -n ${PATCH_VER} ]] && PATCHES=( "${WORKDIR}"/${PATCH_PV} )

src_unpack() {
	# avoid kernel-2_src_unpack
	default
}

src_prepare() {
	# avoid kernel-2_src_prepare
	default
}

src_test() {
	emake headers_check ${xmakeopts}
}

src_install() {
	kernel-2_src_install

	# hrm, build system sucks
	find "${ED}" \( -name '.install' -o -name '*.cmd' \) -delete || die
}
