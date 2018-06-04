# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

POSTGRES_COMPAT=( 9.{4,5,6} 10 )
POSTGRES_USEDEP="server"

inherit  postgres cmake-utils

DESCRIPTION="pgRouting extends PostGIS and PostgreSQL with geospatial routing functionality."
HOMEPAGE="https://pgrouting.org/"
LICENSE="GPL-2 MIT Boost-1.0"

SLOT="0"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/pgRouting/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
IUSE="+drivingdistance doc pdf html"

REQUIRED_USE="html? ( doc ) pdf? ( doc )"

RDEPEND="${POSTGRES_DEP}
	>=dev-db/postgis-2.0
	dev-libs/boost
	drivingdistance? ( sci-mathematics/cgal )
"

DEPEND="
	doc? ( >=dev-python/sphinx-1.1 )
	pdf? ( >=dev-python/sphinx-1.1[latex] )
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
		-DBUILD_MAN=$(usex doc)
		-DWITH_DD=$(usex drivingdistance)
		-DWITH_DOC=$(usex doc)
	)

	cmake-utils_src_configure
}

src_compile() {
	local make_opts
	use doc && make_opts="all doc"
	cmake-utils_src_make ${make_opts}
}

src_install() {
	cmake-utils_src_install

	use doc && doman "${BUILD_DIR}"/doc/man/en/pgrouting.7
	use html && dodoc -r "${BUILD_DIR}"/doc/html
	use pdf && dodoc "${BUILD_DIR}"/doc/latex/en/*.pdf
}
