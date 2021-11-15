# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools

MY_P="${P^g}"

DESCRIPTION="OpenGL binding for Gauche"
HOMEPAGE="http://practical-scheme.net/gauche/"
SRC_URI="mirror://sourceforge/${PN%-*}/${MY_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="cg examples"

RDEPEND="dev-scheme/gauche:=
	media-libs/freeglut
	virtual/opengl
	x11-libs/libXmu
	cg? ( media-gfx/nvidia-cg-toolkit )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-simple.viewer.patch
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-cg.patch
	"${FILESDIR}"/${P}-info.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(usex cg --enable-cg "")
}

src_install() {
	default

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples
		dodoc examples/*.scm
		# install simple
		dodoc -r examples/simple
		# install glbook
		dodoc -r examples/glbook
		dodoc -r examples/images
		# install slbook
		dodoc -r examples/slbook
		# install cg examples
		use cg && dodoc -r examples/cg
	fi
}
