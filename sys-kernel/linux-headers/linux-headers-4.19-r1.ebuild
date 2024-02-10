# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ETYPE="headers"
H_SUPPORTEDARCH="alpha amd64 arc arm arm64 avr32 cris frv hexagon hppa ia64 m68k metag microblaze mips mn10300 nios2 openrisc ppc ppc64 riscv s390 score sh sparc x86 xtensa"
inherit kernel-2 toolchain-funcs
detect_version

PATCH_VER="1"
SRC_URI="mirror://gentoo/gentoo-headers-base-${PV}.tar.xz
	https://dev.gentoo.org/~sam/distfiles/gentoo-headers-base-${PV}.tar.xz
	${PATCH_VER:+mirror://gentoo/gentoo-headers-${PV}-${PATCH_VER}.tar.xz}
	${PATCH_VER:+https://dev.gentoo.org/~sam/distfiles/gentoo-headers-${PV}-${PATCH_VER}.tar.xz}"
S="${WORKDIR}/gentoo-headers-base-${PV}"

KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="
	app-arch/xz-utils
	dev-lang/perl"

[[ -n ${PATCH_VER} ]] && PATCHES=( "${WORKDIR}"/${PV} )

src_unpack() {
	# avoid kernel-2_src_unpack
	default
}

src_prepare() {
	# avoid kernel-2_src_prepare
	default
}

src_test() {
	einfo "Possible unescaped attribute/type usage"
	grep -E -r \
		-e '(^|[[:space:](])(asm|volatile|inline)[[:space:](]' \
		-e '\<([us](8|16|32|64))\>' \
		.

	emake ARCH="$(tc-arch-kernel)" headers_check
}

src_install() {
	kernel-2_src_install

	find "${ED}" \( -name '.install' -o -name '*.cmd' \) -delete || die
	# delete empty directories
	find "${ED}" -empty -type d -delete || die
}
