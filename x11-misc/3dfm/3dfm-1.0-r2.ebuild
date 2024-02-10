# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenGL-based 3D File Manager"
HOMEPAGE="https://sourceforge.net/projects/innolab/"
SRC_URI="mirror://sourceforge/innolab/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	virtual/glu
	virtual/opengl
	media-libs/freeglut"
DEPEND="${RDEPEND}"

src_install() {
	default
	mv "${ED}"/usr/bin/{interface,3dfm} || die
}
