# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES="modules"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
WANT_AUTOMAKE="1.12"

inherit autotools-utils eutils python-r1

MY_PN="PythonMagick"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python bindings for ImageMagick"
HOMEPAGE="http://www.imagemagick.org/script/api.php"
SRC_URI="mirror://imagemagick/python/${MY_P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/boost-1.48[python,${PYTHON_USEDEP}]
	>=media-gfx/imagemagick-6.9.1
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.10-Makefile.am.patch
	"${FILESDIR}"/${PN}-0.9.10-ax_boost_python.patch
)

src_configure() {
	local myeconfargs=( --disable-static )

	python_configure() {
		if ! python_is_python3; then
			local -x CXXFLAGS="${CXXFLAGS} -fno-strict-aliasing"
		fi
		autotools-utils_src_configure --with-boost-python=boost_python-${EPYTHON#python}
	}

	python_parallel_foreach_impl python_configure
}

src_compile() {
	python_foreach_impl autotools-utils_src_compile
}

src_install() {
	python_foreach_impl autotools-utils_src_install
}
