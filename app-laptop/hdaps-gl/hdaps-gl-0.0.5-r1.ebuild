# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="OpenGL visualization for HDAPS data"
HOMEPAGE="http://hdaps.sourceforge.net"
SRC_URI="mirror://sourceforge/hdaps/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND=""
DEPEND="virtual/opengl
	media-libs/freeglut"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-as-needed.diff" )

src_compile() {
	emake CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} ${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	dobin "${PN}"
}
