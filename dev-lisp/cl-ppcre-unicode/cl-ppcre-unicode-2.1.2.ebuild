# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit common-lisp-3

DESCRIPTION="CL-PPCRE is a portable regular expression library for Common Lisp"
HOMEPAGE="https://edicl.github.io/cl-ppcre/
	https://www.cliki.net/cl-ppcre"

SRC_URI="https://github.com/edicl/cl-ppcre/archive/v${PV}.tar.gz -> cl-ppcre-${PV}.tar.gz"
S="${WORKDIR}/cl-ppcre-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv ~sparc ~x86"

RDEPEND="~dev-lisp/cl-ppcre-${PV}
	dev-lisp/cl-unicode"

src_install() {
	common-lisp-install-sources ${PN}/ test/unicode*
	common-lisp-install-asdf ${PN}
}
