# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="a high quality Audio CD to audio file encoder"
HOMEPAGE="http://jk.yazzy.org/projects/vlorb/"
SRC_URI="http://jk.yazzy.org/projects/vlorb/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="ogg"

DEPEND=">=media-sound/cdparanoia-3.9.8
	>=dev-perl/CDDB-1.12
	ogg? ( >=media-sound/vorbis-tools-1.0.1 )"

src_compile() { :; }

src_install() {
	dodoc ChangeLog README
	dobin vlorb
	doman vlorb.1
}
