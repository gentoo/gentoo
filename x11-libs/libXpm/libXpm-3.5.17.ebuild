# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_DOC=doc
XORG_MULTILIB=yes
XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="X.Org Xpm library"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
	>=x11-libs/libXt-1.1.4[${MULTILIB_USEDEP}]

	app-alternatives/gzip
	app-arch/ncompress
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	test? ( >=dev-libs/glib-2.46:2 )
"
BDEPEND="
	sys-devel/gettext
	test? (
		app-arch/gzip
		app-arch/ncompress
	)
"

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		$(use_enable test unit-tests)
	)
	xorg-3_src_configure
}
