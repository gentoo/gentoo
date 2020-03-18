# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

POSTGRES_COMPAT=( 9.{4..6} 10 11 )
POSTGRES_USEDEP="server"

inherit  postgres cmake-utils

DESCRIPTION="pgRouting extends PostGIS and PostgreSQL with geospatial routing functionality."
HOMEPAGE="http://pgrouting.org/"
LICENSE="GPL-2 MIT Boost-1.0"

SLOT="0"
KEYWORDS="amd64 x86"
SRC_URI="https://github.com/pgRouting/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
IUSE="pdf html"

RDEPEND="${POSTGRES_DEP}
	>=dev-db/postgis-2.0
	dev-libs/boost
	sci-mathematics/cgal
"

# Sphinx is needed to build the man pages
DEPEND="${RDEPEND}
	>=dev-python/sphinx-1.2
	pdf? ( >=dev-python/sphinx-1.2[latex] )
"

# Needs a running psql instance, doesn't work out of the box
RESTRICT="test"

pkg_setup() {
	postgres_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_HTML=$(usex html)
		-DBUILD_LATEX=$(usex pdf)
		-DBUILD_MAN=ON
		-DWITH_DOC=ON
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make all doc
}

src_install() {
	cmake-utils_src_install

	doman "${BUILD_DIR}"/doc/man/en/pgrouting.7

	use html && dodoc -r "${BUILD_DIR}"/doc/html
	use pdf && dodoc "${BUILD_DIR}"/doc/latex/en/*.pdf
}
