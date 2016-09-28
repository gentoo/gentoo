# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A general purpose fuzzer"
HOMEPAGE="https://github.com/aoh/radamsa"
SRC_URI="https://github.com/aoh/radamsa/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT=test # needs an owl-lisp

DOCS=( LICENCE NEWS README.md )

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	emake install DESTDIR="${D}" PREFIX="${EPREFIX}/usr"

	einstalldocs
}
