# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="A library to read and write PLY files"
HOMEPAGE="http://w3.impa.br/~diego/software/rply/"
# SRC_URI="http://w3.impa.br/~diego/software/rply/${P}.tar.gz"
# Tarball no longer available from upstream website
SRC_URI="https://dev.gentoo.org/~tetromino/distfiles/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=(
	# Use int16_t and int32_t instead of assuming e.g. that sizeof(long) == 4
	"${FILESDIR}/${P}-stdint.h.patch"
	# Switch LC_NUMERIC locale to "C" to ensure "." is the decimal separator
	"${FILESDIR}/${P}-lc_numeric.patch"
)

pkg_setup() {
	use doc && HTML_DOCS="manual/*"
}

src_prepare() {
	# rply doesn't have *any* build system - not even a Makefile!
	# For simplicity, use the cmake file that Fedora maintainers have created
	cp "${FILESDIR}/rply_CMakeLists.txt" CMakeLists.txt || die
	mkdir -p CMake/export || die

	cmake-utils_src_prepare
}
