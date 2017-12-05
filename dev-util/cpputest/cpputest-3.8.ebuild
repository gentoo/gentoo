# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="unit testing and mocking framework for C/C++"
HOMEPAGE="https://cpputest.github.io/ https://github.com/cpputest/cpputest"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

DEPEND="
	test? (
		dev-cpp/gmock
		dev-cpp/gtest
	)
"

DOCS=( AUTHORS README.md README_CppUTest_for_C.txt )
