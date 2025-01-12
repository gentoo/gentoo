# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Unit testing and mocking framework for C/C++"
HOMEPAGE="https://cpputest.github.io/ https://github.com/cpputest/cpputest"
SRC_URI="https://github.com/cpputest/cpputest/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( >=dev-cpp/gtest-1.8.0 )"

DOCS=( AUTHORS README.md README_CppUTest_for_C.txt )

PATCHES=(
	"${FILESDIR}"/${PN}-4.0-autoconf.patch
	"${FILESDIR}"/${P}-replace-UB-by-abort.patch
)

src_prepare() {
	default
	eautoreconf
}
