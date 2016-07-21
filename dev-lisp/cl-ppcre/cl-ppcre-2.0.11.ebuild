# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit common-lisp-3

MY_P="v${PV}"

DESCRIPTION="CL-PPCRE is a portable regular expression library for Common Lisp."
HOMEPAGE="http://weitz.de/cl-ppcre/
		  http://www.cliki.net/cl-ppcre"
SRC_URI="https://github.com/edicl/${PN}/archive/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="dev-lisp/flexi-streams"
PDEPEND="dev-lisp/cl-ppcre-unicode"

src_unpack() {
	unpack ${A} && cd "${S}"
	rm -rf cl-ppcre-unicode test/unicode*
}

src_install() {
	common-lisp-install-sources *.lisp test/
	common-lisp-install-asdf ${PN}
	dodoc CHANGELOG
	dohtml doc/index.html
}
