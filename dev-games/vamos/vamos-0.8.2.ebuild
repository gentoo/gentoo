# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit autotools python-single-r1

DESCRIPTION="An automotive simulation framework"
HOMEPAGE="http://vamos.sourceforge.net/"
SRC_URI="mirror://sourceforge/vamos/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/boost:=[python,${PYTHON_USEDEP}]
	media-libs/freealut
	media-libs/freeglut
	media-libs/libpng:0=
	media-libs/libsdl[joystick,video]
	media-libs/openal
	virtual/glu
	virtual/opengl"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-archive-2016.09.16
	virtual/pkgconfig"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.2-fix-buildsystem.patch
	"${FILESDIR}"/${PN}-0.8.2-fix-c++14.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--with-x \
		--disable-static \
		--with-boost-python="${EPYTHON#python}" \
		$(use_enable test unit-tests) \
		PYTHON="${EPYTHON}"
}

src_install() {
	MAKEOPTS="${MAKEOPTS} -j1" default #646014

	dobin caelum/.libs/caelum
	newdoc caelum/README README.caelum

	find "${D}" -name '*.la' -delete || die
}
