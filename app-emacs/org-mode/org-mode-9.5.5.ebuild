# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25.1

inherit elisp readme.gentoo-r1

MY_P="${PN}-release_${PV}"
DESCRIPTION="An Emacs mode for notes and project planning"
HOMEPAGE="https://www.orgmode.org/"
SRC_URI="https://git.savannah.gnu.org/cgit/emacs/${PN}.git/snapshot/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-3+ FDL-1.3+ CC-BY-SA-3.0 odt-schema? ( OASIS-Open )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc odt-schema"
RESTRICT="test"

BDEPEND="doc? ( virtual/texi2dvi )"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	emake \
		ORGVERSION=${PV} \
		datadir="${EPREFIX}${SITEETC}/${PN}"
	use doc && emake pdf card
}

src_install() {
	emake \
		ORGVERSION=${PV} \
		DESTDIR="${D}" \
		ETCDIRS="styles csl $(use odt-schema && echo schema)" \
		lispdir="${EPREFIX}${SITELISP}/${PN}" \
		datadir="${EPREFIX}${SITEETC}/${PN}" \
		infodir="${EPREFIX}/usr/share/info" \
		install

	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc README CONTRIBUTE etc/ORG-NEWS
	use doc && dodoc doc/org.pdf doc/orgcard.pdf doc/orgguide.pdf

	local DOC_CONTENTS="Org mode has a large variety of run-time dependencies,
		so you may have to install one or more additional packages.
		A non-exhaustive list of these dependencies may be found at
		<http://orgmode.org/worg/org-dependencies.html>."
	readme.gentoo_create_doc
}
