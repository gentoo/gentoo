# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/limit/limit-1.14.10_pre200811252332.ebuild,v 1.7 2014/02/18 19:53:10 ulm Exp $

EAPI=5

inherit elisp

MY_PV="${PV/./_}"; MY_PV="${MY_PV/.*_pre/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Library about Internet Message, for IT generation"
HOMEPAGE="http://git.chise.org/elisp/flim/"
SRC_URI="http://www.jpl.org/ftp/pub/m17n/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"

DEPEND=">=app-emacs/apel-10.3"
RDEPEND="${DEPEND}
	!app-emacs/flim"

S="${WORKDIR}/${MY_P}"
SITEFILE="60flim-gentoo.el"

src_compile() {
	emake PREFIX="${D}/usr" \
		LISPDIR="${D}/${SITELISP}" \
		VERSION_SPECIFIC_LISPDIR="${D}/${SITELISP}"
}

src_install() {
	emake PREFIX="${D}/usr" \
		LISPDIR="${D}/${SITELISP}" \
		VERSION_SPECIFIC_LISPDIR="${D}/${SITELISP}" install

	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	dodoc FLIM-API.en NEWS VERSION README* ChangeLog
}
