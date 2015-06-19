# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/org-mode/org-mode-8.2.6.ebuild,v 1.5 2014/08/03 18:36:52 ago Exp $

EAPI=5

inherit elisp

DESCRIPTION="An Emacs mode for notes and project planning"
HOMEPAGE="http://www.orgmode.org/"
SRC_URI="http://orgmode.org/org-${PV}.tar.gz"

LICENSE="GPL-3+ FDL-1.3+ contrib? ( GPL-2+ MIT ) odt-schema? ( OASIS-Open )"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd ~x86-macos"
IUSE="contrib doc odt-schema"
RESTRICT="test"

DEPEND="doc? ( virtual/texi2dvi )"

S="${WORKDIR}/org-${PV}"
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	emake datadir="${EPREFIX}${SITEETC}/${PN}"
	use doc && emake pdf card
}

src_install() {
	emake \
		DESTDIR="${D}" \
		ETCDIRS="styles $(use odt-schema && echo schema)" \
		lispdir="${EPREFIX}${SITELISP}/${PN}" \
		datadir="${EPREFIX}${SITEETC}/${PN}" \
		infodir="${EPREFIX}/usr/share/info" \
		install

	cp "${FILESDIR}/${SITEFILE}" "${T}/${SITEFILE}" || die

	if use contrib; then
		elisp-install ${PN}/contrib contrib/lisp/{org,ob,ox}*.el
		insinto /usr/share/doc/${PF}/contrib
		doins -r contrib/README contrib/scripts
		find "${ED}/usr/share/doc/${PF}/contrib" -type f -name '.*' \
			-exec rm -f '{}' '+'
		# add the contrib subdirectory to load-path
		sed -i -e 's:\(.*@SITELISP@\)\(.*\):&\n\1/contrib\2:' \
			"${T}/${SITEFILE}" || die
	fi

	elisp-site-file-install "${T}/${SITEFILE}"
	dodoc README doc/library-of-babel.org doc/orgcard.txt etc/ORG-NEWS
	use doc && dodoc doc/org.pdf doc/orgcard.pdf doc/orgguide.pdf
}
