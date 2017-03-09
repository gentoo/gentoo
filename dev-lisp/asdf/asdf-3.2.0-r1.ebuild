# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils prefix

DESCRIPTION="ASDF is Another System Definition Facility for Common Lisp"
HOMEPAGE="http://common-lisp.net/project/asdf/"
SRC_URI="http://common-lisp.net/project/${PN}/archives/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x86-solaris"
IUSE="doc"

SLOT="0/${PVR}"

DEPEND="!dev-lisp/cl-${PN}
		!dev-lisp/asdf-binary-locations
		!dev-lisp/gentoo-init
		!<dev-lisp/asdf-2.33-r3
		doc? ( virtual/texi2dvi )"
RDEPEND=""
PDEPEND="~dev-lisp/uiop-${PV}"

install_docs() {
	# Not installing info file at the moment, see bug #605752
	(cd doc ; dodoc *.{html,css,ico,png} "${PN}.pdf" ; dodoc -r asdf)
}

src_compile() {
	make
	use doc && make -C doc
}

src_install() {
	insinto "/usr/share/common-lisp/source/${PN}"
	doins -r build version.lisp-expr
	dodoc README.md TODO
	use doc && install_docs
	insinto /etc/common-lisp
	cd "${T}" || die
	cp "${FILESDIR}/gentoo-init.lisp" "${FILESDIR}/source-registry.conf" . || die
	eprefixify gentoo-init.lisp source-registry.conf
	doins gentoo-init.lisp source-registry.conf
}
