# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit common-lisp-3 eutils

DESCRIPTION="CLX is the Common Lisp interface to the X11 protocol primarily for SBCL."
HOMEPAGE="http://www.cliki.net/CLX"
SRC_URI="http://common-lisp.net/~abridgewater/dist/${PN}/${P}.tgz"

LICENSE="CLX"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc"

DEPEND="sys-apps/texinfo
		doc? ( virtual/texi2dvi )"
RDEPEND="!dev-lisp/cl-${PN}"

src_prepare() {
	rm -v {exclcmac,sockcl,defsystem,provide,cmudep}.lisp || die
	epatch "${FILESDIR}"/gentoo-fix-asd.patch
	epatch "${FILESDIR}"/gentoo-fix-dep-openmcl.patch
	epatch "${FILESDIR}"/gentoo-fix-unused-vars.patch
	epatch "${FILESDIR}"/gentoo-fix-obsolete-eval-when.patch
	epatch "${FILESDIR}"/gentoo-fix-dynamic-extent-sbcl-1.0.45.patch
}

src_compile() {
	cd manual || die
	makeinfo ${PN}.texinfo -o ${PN}.info || die "Cannot compile info docs"
	if use doc ; then
		VARTEXFONTS="${T}"/fonts \
			texi2pdf ${PN}.texinfo -o ${PN}.pdf || die "Cannot build PDF docs"
	fi
}

src_install() {
	common-lisp-install-sources *.lisp debug demo test
	common-lisp-install-asdf
	dodoc NEWS CHANGES README*
	doinfo manual/${PN}.info
	use doc && dodoc manual/${PN}.pdf
}
