# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${PN}${PV}_src"

DESCRIPTION="Multiple sequence comparison by log-expectation"
HOMEPAGE="http://www.drive5.com/muscle/"
SRC_URI="http://www.drive5.com/muscle/downloads${PV}/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="!sci-libs/libmuscle"

S="${WORKDIR}"/${PN}${PV}/src

PATCHES=( "${FILESDIR}"/${PV}-make.patch )

src_configure() {
	tc-export CXX
}

src_install() {
	dobin muscle
	dodoc *.txt
}
