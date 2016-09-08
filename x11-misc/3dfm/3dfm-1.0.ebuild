# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="OpenGL-based 3D File Manager"
HOMEPAGE="https://sourceforge.net/projects/innolab/"
SRC_URI="mirror://sourceforge/innolab/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="virtual/glu
	virtual/opengl
	media-libs/freeglut"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die
	mv "${D}"/usr/bin/interface "${D}"/usr/bin/3dfm || die

	dodoc AUTHORS ChangeLog README
}
