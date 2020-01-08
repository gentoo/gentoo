# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit xorg-2

DESCRIPTION="X.Org Xaw3d library"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="unicode xpm"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
	xpm? ( x11-libs/libXpm )"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/yacc
	x11-base/xorg-proto"

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable unicode internationalization)
		$(use_enable xpm multiplane-bitmaps)
		--enable-arrow-scrollbars
		--enable-gray-stipples
	)

	xorg-2_pkg_setup
}
