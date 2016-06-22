# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit elisp

DESCRIPTION="A redesign of Liece IRC client"
HOMEPAGE="http://www.nongnu.org/riece/"
SRC_URI="http://download.savannah.gnu.org/releases/riece/${P}.tar.gz"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="l10n_ja"
RESTRICT="test"

SITEFILE="50${PN}-gentoo.el"

src_configure() {
	econf --with-lispdir="${EPREFIX}${SITELISP}"
}

src_compile() {
	default
}

src_install() {
	emake DESTDIR="${D}" \
		lispdir="${ED}${SITELISP}" \
		install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc AUTHORS NEWS README doc/HACKING lisp/ChangeLog*

	if use l10n_ja; then
		dodoc NEWS.ja README.ja doc/HACKING.ja
	else
		rm -f "${ED}"/usr/share/info/riece-ja.info*
	fi
}
