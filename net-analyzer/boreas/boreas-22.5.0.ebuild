# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Greenbone Scanner for alive hosts"
HOMEPAGE="https://www.greenbone.net https://github.com/greenbone/boreas"
SRC_URI="https://github.com/greenbone/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/glib-2.42:2
	>=net-analyzer/gvm-libs-22.4.1
	net-libs/libpcap
"
RDEPEND="${DEPEND}"

BDEPEND="
	doc? (
		app-text/doxygen
		app-text/xmltoman
	)
	test? ( dev-libs/cgreen )
"

PATCHES=(
	# Fix cmake error https://cmake.org/cmake/help/latest/policy/CMP0004.html
	# PR upstream: https://github.com/greenbone/boreas/pull/66
	"${FILESDIR}"/boreas-22.5.0-fix-leading-withespaces-ldflags-libpcap.patch
)

src_configure() {
	local mycmakeargs=(
		"-DLOCALSTATEDIR=${EPREFIX}/var"
		"-DSYSCONFDIR=${EPREFIX}/etc"
		"-DBINDIR=${EPREFIX}/usr/bin"
	)
	cmake_src_configure
}
