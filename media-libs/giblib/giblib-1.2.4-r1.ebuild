# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit eutils libtool

DESCRIPTION="a graphics library built on top of imlib2"
HOMEPAGE="http://freecode.com/projects/giblib http://www.linuxbrit.co.uk/giblib/"
SRC_URI="http://www.linuxbrit.co.uk/downloads/${P}.tar.gz"

LICENSE="feh"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="static-libs"

RDEPEND=">=media-libs/imlib2-1.0.3[X]
	x11-libs/libX11
	x11-libs/libXext
	>=media-libs/freetype-2.0"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i 's:@LDFLAGS@::' giblib-config.in giblib.pc.in || die #430724
	sed -i "/^docsdir/s:=.*:= @datadir@/doc/${PF}:" Makefile.in || die
	epunt_cxx
	elibtoolize # otherwise it doesnt install the .so -> .so.x symlink on fbsd
}

src_configure() {
	econf $(use_enable static-libs static)
}
