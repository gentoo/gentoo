# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit autotools python-single-r1

DESCRIPTION="IlmBase Python bindings"
HOMEPAGE="https://www.openexr.com"
SRC_URI="https://github.com/openexr/openexr/releases/download/v${PV}/${P}.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+numpy"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/boost-1.62.0-r1[python(+),${PYTHON_USEDEP}]
	~media-libs/ilmbase-${PV}:=
	numpy? ( >=dev-python/numpy-1.10.4 )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=virtual/pkgconfig-0-r1"

PATCHES=(
	"${FILESDIR}/${P}-link-pyimath.patch"
	"${FILESDIR}/${P}-fix-build-system.patch"
)

DOCS=( README.md )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local boostpython_ver="${EPYTHON:6}"
	if has_version ">=dev-libs/boost-1.70.0"; then
		boostpython_ver="${boostpython_ver/./}"
	else
		boostpython_ver="-${boostpython_ver}"
	fi

	local myeconfargs=(
		--with-boost-include-dir="${EPREFIX}/usr/include/boost"
		--with-boost-lib-dir="${EPREFIX}/usr/$(get_libdir)"
		--with-boost-python-libname="boost_python${boostpython_ver}"
		$(use_with numpy)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	# Fails to install with multiple jobs
	emake DESTDIR="${D}" -j1 install

	einstalldocs

	# package provides pkg-config files
	find "${D}" -name '*.la' -delete || die
}
