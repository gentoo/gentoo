# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_P="${PN}${PV}_src"

DESCRIPTION="Multiple sequence comparison by log-expectation"
HOMEPAGE="https://www.drive5.com/muscle/"
SRC_URI="https://www.drive5.com/muscle/downloads${PV}/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"

RDEPEND="!sci-libs/libmuscle"

S="${WORKDIR}"/${PN}${PV}/src

PATCHES=( "${FILESDIR}"/${PV}-make.patch )

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/862276
	# Fixed upstream in later releases
	#
	# Do not trust with LTO either.
	append-flags -fno-strict-aliasing
	filter-lto

	tc-export CXX
}

src_install() {
	dobin muscle
	dodoc *.txt
}
