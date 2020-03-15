# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${P/-/_}"

DESCRIPTION="A library for creating and verifying Usenet cancel locks"
HOMEPAGE="https://packages.qa.debian.org/c/canlock.html"
SRC_URI="
	mirror://debian/pool/main/c/${PN}/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/c/${PN}/${MY_P}-6.diff.gz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}/${P/-/}"

PATCHES=(
	"${WORKDIR}"/${MY_P}-6.diff
	"${FILESDIR}"/${P}-make.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dolib.so src/libcanlock.so.2.0.0
	dosym libcanlock.so.2.0.0 /usr/$(get_libdir)/libcanlock.so.2
	dosym libcanlock.so.2.0.0 /usr/$(get_libdir)/libcanlock.so

	doheader include/canlock.h

	dodoc CHANGES README doc/HOWTO
}
