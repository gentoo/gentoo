# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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
	default
	mv "${ED%/}"/usr/bin/{interface,3dfm} || die
}
