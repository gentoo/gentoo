# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit common-lisp-3

DESCRIPTION="A collection of portable utilities for Common Lisp"
HOMEPAGE="http://common-lisp.net/project/alexandria/ https://gitlab.common-lisp.net/alexandria/alexandria"
SRC_URI="https://gitlab.common-lisp.net/${PN}/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc"

# sbcl is hardcoded in Makefile
BDEPEND="doc? (
	dev-lisp/sbcl
	sys-apps/texinfo
)
"

DOCS=( README AUTHORS )

src_compile() {
	use doc && emake -C doc
}

src_install() {
	common-lisp-install-sources -t all alexandria-1 alexandria-2 LICENCE
	common-lisp-install-asdf
	if use doc; then
		doinfo doc/${PN}.info
		HTML_DOCS=( doc/{"${PN}.html","${PN}.pdf"} )
	fi
	einstalldocs
}
