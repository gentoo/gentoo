# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils

DESCRIPTION="Tool which allows you to compose wallpapers ('root pixmaps') for X"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://cdn.thegraveyard.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND="x11-libs/libX11
	>=media-libs/imlib2-1.0.6.2003[X]"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	epatch "${FILESDIR}"/${P}-underlinking.patch
	# The pre-generated configure script contains unneeded deps
	eautoreconf
}
