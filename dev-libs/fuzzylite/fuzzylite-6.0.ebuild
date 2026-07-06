# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="A fuzzy logic control library in C++"
HOMEPAGE="https://www.fuzzylite.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/${PN}"

LICENSE="|| ( Apache-2.0 GPL-3 )"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="static-libs"

DOCS="../README.md"

src_prepare() {
	default

	sed -i -e "/cmake_minimum_required/ s|2\.8\.8|3.10|" \
		CMakeLists.txt || die

	# Fix upstream pkg-config template: FL_VERSION is unset and libdir is hardcoded.
	sed -i \
		-e "s|libdir=\${exec_prefix}/lib|libdir=\${exec_prefix}/@FL_INSTALL_LIBDIR@|" \
		-e "s|@FL_VERSION@|${PV}|" \
		fuzzylite.pc.in || die

	cmake_prepare
}

src_configure() {
	local mycmakeargs=(
		-DFL_BUILD_STATIC=$(usex static-libs)
		-DFL_USE_FLOAT=OFF
		-DFL_BACKTRACE=ON
		-DFL_BUILD_TESTS=OFF
	)
	append-cxxflags -Wno-deprecated-declarations
	cmake_src_configure
}
