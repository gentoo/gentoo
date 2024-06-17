# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit common-lisp-3

DESCRIPTION="CL-PPCRE is a portable regular expression library for Common Lisp"
HOMEPAGE="https://edicl.github.io/cl-ppcre/
	https://www.cliki.net/cl-ppcre"
SRC_URI="https://github.com/edicl/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"

RDEPEND="dev-lisp/flexi-streams"
PDEPEND="dev-lisp/cl-ppcre-unicode"

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	rm -rf cl-ppcre-unicode test/unicode* || die
}

src_install() {
	common-lisp-install-sources *.lisp test/
	common-lisp-install-asdf ${PN}
	dodoc CHANGELOG docs/index.html
}
