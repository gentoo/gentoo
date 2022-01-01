# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="An easy-to-use hash implementation for C programmers"
HOMEPAGE="https://troydhanson.github.io/uthash/index.html"
SRC_URI="https://github.com/troydhanson/uthash/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-1"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-lang/perl )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.0-cflags.patch
)

src_test() {
	cd tests || die
	emake CC="$(tc-getCC)"
}

src_install() {
	doheader src/*.h
	dodoc doc/*.txt
}
