# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_DOC=doc
XORG_MULTILIB=yes
inherit xorg-3

DESCRIPTION="X.Org X Toolkit Intrinsics library"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=x11-libs/libICE-1.0.8-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libSM-1.2.1-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	test? ( dev-libs/glib[${MULTILIB_USEDEP}] )"

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		$(use_with doc xmlto)
		$(use_enable doc specs)
		$(use_enable test unit-tests)
		--without-fop
	)
	xorg-3_src_configure
}
