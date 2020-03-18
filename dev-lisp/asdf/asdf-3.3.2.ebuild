# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils prefix common-lisp-3

DESCRIPTION="ASDF is Another System Definition Facility for Common Lisp"
HOMEPAGE="http://common-lisp.net/project/asdf/"
SRC_URI="http://common-lisp.net/project/${PN}/archives/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PVR}"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x86-solaris"
IUSE="doc"

DEPEND="!dev-lisp/cl-${PN}
		!<dev-lisp/asdf-2.33-r3
		doc? ( virtual/texi2dvi )"
PDEPEND="virtual/commonlisp
		~dev-lisp/uiop-${PV}"

install_docs() {
	(cd doc ; dodoc *.{html,css,ico,png} "${PN}.pdf" ; dodoc -r asdf )
	if has_version ">=dev-lisp/sbcl-1.4.0" ; then
		(cd doc ; doinfo "${PN}.info" )
	fi
}

src_compile() {
	emake
	use doc && emake -C doc
}

src_test() {
	common-lisp-export-impl-args "$(common-lisp-find-lisp-impl)"
	test/run-tests.sh ${CL_BINARY}
}

src_install() {
	insinto "${CLSOURCEROOT}/${PN}"
	doins -r build version.lisp-expr
	dodoc README.md TODO
	use doc && install_docs
	insinto /etc/common-lisp
	cd "${T}" || die
	cp "${FILESDIR}/gentoo-init.lisp" "${FILESDIR}/source-registry.conf" . || die
	eprefixify gentoo-init.lisp source-registry.conf
	doins gentoo-init.lisp source-registry.conf
}
