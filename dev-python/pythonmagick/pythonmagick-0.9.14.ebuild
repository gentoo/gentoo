# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )
WANT_AUTOMAKE="1.12"

inherit autotools eutils python-r1

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

src_prepare() {
	default
	eautoreconf
	python_copy_sources
}

src_configure() {
	python_configure() {
		if ! python_is_python3; then
			local -x CXXFLAGS="${CXXFLAGS} -fno-strict-aliasing"
		fi
		econf \
			--disable-static \
			--with-boost-python=boost_python-${EPYTHON#python}
	}

	python_foreach_impl run_in_build_dir python_configure
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	python_foreach_impl run_in_build_dir default
	prune_libtool_files --modules
}
