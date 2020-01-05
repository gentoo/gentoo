# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit libtool python-r1

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

src_prepare() {
	default
	elibtoolize
	python_copy_sources
}

src_configure() {
	python_configure() {
		econf \
			--disable-static \
			--with-boost-python=boost_python-${EPYTHON#python}
	}

	python_foreach_impl run_in_build_dir python_configure
}

src_compile() {
	python_foreach_impl run_in_build_dir emake
}

src_test() {
	python_foreach_impl run_in_build_dir emake check
}

src_install() {
	python_foreach_impl run_in_build_dir emake DESTDIR="${D}" install
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
