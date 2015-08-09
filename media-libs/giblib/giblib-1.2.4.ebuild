# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit toolchain-funcs eutils

DESCRIPTION="Giblib, graphics library"
HOMEPAGE="http://www.linuxbrit.co.uk/giblib/"
SRC_URI="http://www.linuxbrit.co.uk/downloads/${P}.tar.gz"

LICENSE="feh"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=media-libs/imlib2-1.0.3[X]
	x11-libs/libX11
	x11-libs/libXext
	>=media-libs/freetype-2.0"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epunt_cxx
}

src_install() {
	emake DESTDIR="${D}" install || die
	rm -r "${D}"/usr/doc
	dodoc README AUTHORS ChangeLog TODO
}
