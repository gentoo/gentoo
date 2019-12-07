# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="unit testing and mocking framework for C/C++"
HOMEPAGE="https://cpputest.github.io/ https://github.com/cpputest/cpputest"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( >=dev-cpp/gtest-1.8.0 )"

DOCS=( AUTHORS README.md README_CppUTest_for_C.txt )
