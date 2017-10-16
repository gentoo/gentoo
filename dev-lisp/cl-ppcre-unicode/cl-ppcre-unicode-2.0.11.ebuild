# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit common-lisp-3

DESCRIPTION="CL-PPCRE is a portable regular expression library for Common Lisp."
HOMEPAGE="http://weitz.de/cl-ppcre/
		  http://www.cliki.net/cl-ppcre"
SRC_URI="https://github.com/edicl/cl-ppcre/archive/v${PV}.tar.gz -> cl-ppcre-${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="=dev-lisp/cl-ppcre-${PV}
		dev-lisp/cl-unicode"

S="${WORKDIR}/cl-ppcre-${PV}"

src_install() {
	common-lisp-install-sources ${PN}/ test/unicode*
	common-lisp-install-asdf ${PN}
}
