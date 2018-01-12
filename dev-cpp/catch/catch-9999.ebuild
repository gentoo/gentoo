# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/catchorg/Catch2.git"
inherit cmake-utils git-r3

DESCRIPTION="Modern C++ header-only framework for unit-tests"
HOMEPAGE="https://github.com/catchorg/Catch2"
SRC_URI=""

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS=""
IUSE="test"

src_configure() {
	local mycmakeargs=(
		-DNO_SELFTEST=$(usex !test)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc -r docs/.
}
