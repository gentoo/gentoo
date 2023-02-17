# Copyright 2018-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ wrapper for libcURL"
HOMEPAGE="https://www.curlpp.org/"
SRC_URI="https://github.com/jpbarrette/curlpp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples"

RDEPEND="net-misc/curl"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-fix-pkgconfig.patch )

src_install() {
	DOCS=( Readme.md doc/AUTHORS doc/TODO )
	use doc && DOCS+=( doc/guide.pdf )

	cmake_src_install

	if use examples; then
		dodoc -r examples/
	fi
}
