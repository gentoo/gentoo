# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit xorg-2

DESCRIPTION="X.Org Xaw3d library"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="unicode"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/yacc
	x11-proto/xextproto
	x11-proto/xproto"

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable unicode internationalization)
		--enable-arrow-scrollbars
		--enable-gray-stipples
	)

	xorg-2_pkg_setup
}
