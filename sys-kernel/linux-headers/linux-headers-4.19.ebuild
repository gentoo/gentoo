# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

ETYPE="headers"
H_SUPPORTEDARCH="alpha amd64 arc arm arm64 avr32 cris frv hexagon hppa ia64 m68k metag microblaze mips mn10300 nios2 openrisc ppc ppc64 riscv s390 score sh sparc x86 xtensa"
inherit kernel-2 toolchain-funcs
detect_version

PATCH_VER="1"
SRC_URI="mirror://gentoo/gentoo-headers-base-${PV}.tar.xz
	https://dev.gentoo.org/~sam/distfiles/gentoo-headers-base-${PV}.tar.xz
	${PATCH_VER:+mirror://gentoo/gentoo-headers-${PV}-${PATCH_VER}.tar.xz}
	${PATCH_VER:+https://dev.gentoo.org/~sam/distfiles/gentoo-headers-${PV}-${PATCH_VER}.tar.xz}
"

KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

DEPEND="app-arch/xz-utils
	dev-lang/perl"
RDEPEND=""

S=${WORKDIR}/gentoo-headers-base-${PV}

src_unpack() {
	unpack ${A}
}

src_prepare() {
	default

	[[ -n ${PATCH_VER} ]] && eapply "${WORKDIR}"/${PV}/*.patch
}

src_test() {
	einfo "Possible unescaped attribute/type usage"
	egrep -r \
		-e '(^|[[:space:](])(asm|volatile|inline)[[:space:](]' \
		-e '\<([us](8|16|32|64))\>' \
		.

	emake ARCH=$(tc-arch-kernel) headers_check
}

src_install() {
	kernel-2_src_install

	find "${ED}" '(' -name '.install' -o -name '*.cmd' ')' -delete
	find "${ED}" -depth -type d -delete 2>/dev/null
}
