# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit common-lisp

DESCRIPTION="CL-PPCRE is a portable regular expression library for Common Lisp"
HOMEPAGE="http://weitz.de/cl-ppcre/
	http://www.cliki.net/cl-ppcre"
SRC_URI="mirror://gentoo/${PN}_${PV}.orig.tar.gz"
LICENSE="BSD"
KEYWORDS="amd64 ~ppc ~sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp"
SLOT="0"

CLPACKAGE=cl-ppcre

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
	dodoc CHANGELOG README doc/benchmarks.2002-12-22.txt
	dohtml doc/index.html
}
