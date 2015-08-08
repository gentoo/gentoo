# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils multilib

DESCRIPTION="a dockapp for monitoring disk activities with fancy visuals"
HOMEPAGE="http://hules.free.fr/wmhdplop"
SRC_URI="http://hules.free.fr/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND="media-libs/imlib2[X]
	x11-libs/libX11
	x11-libs/libXext
	media-fonts/corefonts
	>=media-libs/freetype-2"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

src_prepare() {
	epatch "${FILESDIR}"/${P}-64bit.patch
	sed -i -e "s:-O3 -fomit-frame-pointer -ffast-math:${CFLAGS}:" "${S}"/configure
}

src_configure() {
	econf --disable-gkrellm
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README || die
}
