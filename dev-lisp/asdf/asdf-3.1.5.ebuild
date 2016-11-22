# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils prefix

DESCRIPTION="ASDF is Another System Definition Facility for Common Lisp"
HOMEPAGE="http://common-lisp.net/project/asdf/"
SRC_URI="http://common-lisp.net/project/${PN}/archives/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x86-solaris"
IUSE="doc"

SLOT="0/${PVR}"

DEPEND="!dev-lisp/cl-${PN}
		!dev-lisp/asdf-binary-locations
		!dev-lisp/gentoo-init
		!<dev-lisp/asdf-2.33-r3
		doc? ( virtual/texi2dvi )"
RDEPEND=""
PDEPEND="~dev-lisp/uiop-${PV}"

#S="${WORKDIR}"

src_compile() {
	make
	use doc && make doc
}

src_install() {
	insinto /usr/share/common-lisp/source/${PN}
	doins -r build version.lisp-expr
	dodoc README.md TODO
	dohtml doc/*.{html,css,ico,png}
	if use doc; then
		dohtml -r doc/index.html
		insinto /usr/share/doc/${PF}
		#doins doc/${PN}.pdf
	fi

	insinto /etc/common-lisp
	cd "${T}"
	cp "${FILESDIR}"/gentoo-init.lisp "${FILESDIR}"/source-registry.conf .
	eprefixify gentoo-init.lisp source-registry.conf
	doins gentoo-init.lisp source-registry.conf
}
