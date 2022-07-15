# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}${PV}_src"
inherit cmake flag-o-matic

DESCRIPTION="Fast, accurate chimera detection"
HOMEPAGE="https://www.drive5.com/usearch/manual/uchime_algo.html"
SRC_URI="https://www.drive5.com/${PN}/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt . || die
	cmake_src_prepare
}

src_configure() {
	# "myutils.h: error: reference to byte is ambiguous""
	# bug #786297
	append-cxxflags -std=c++14

	cmake_src_configure
}
