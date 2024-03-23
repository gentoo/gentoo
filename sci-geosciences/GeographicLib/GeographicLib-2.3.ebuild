# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="${PN,,}"

DESCRIPTION="C++ library for converting geographic coordinate systems"
HOMEPAGE="https://sourceforge.net/projects/geographiclib/ https://github.com/geographiclib/geographiclib"
SRC_URI="mirror://sourceforge/${MY_PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/26"
KEYWORDS="~amd64 ~arm"
IUSE="doc"

BDEPEND="
	doc? (
		>=app-text/doxygen-1.8.7
		>=dev-lang/perl-5.26.1-r1
		>=dev-python/sphinx-1.6.3-r2
		>=sys-apps/util-linux-2.31
	)
"

src_configure() {
	export GEODATAPATH="/usr/share/${MY_PN}"

	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DDOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DEXAMPLEDIR="${EPREFIX}/usr/share/doc/${PF}/examples"
		-DBUILD_SHARED_LIBS=ON
		-DGEOGRAPHICLIB_DATA="${GEODATAPATH}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto "/usr/share/maxima/${MY_PN}"
	doins -r maxima/.

	find "${D}" -name "*.la" -delete || die
}
