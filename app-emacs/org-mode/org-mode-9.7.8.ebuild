# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp readme.gentoo-r1

DESCRIPTION="An Emacs mode for notes and project planning"
HOMEPAGE="https://orgmode.org/"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://git.savannah.gnu.org/git/emacs/${PN}.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/org"
	S="${WORKDIR}/org"
else
	MY_P="${PN}-release_${PV}"
	SRC_URI="https://git.savannah.gnu.org/cgit/emacs/${PN}.git/snapshot/${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"

	KEYWORDS="~amd64 ~ppc ~x86"
fi

LICENSE="GPL-3+ FDL-1.3+ CC-BY-SA-3.0 odt-schema? ( OASIS-Open )"
SLOT="0"
IUSE="doc odt-schema"
RESTRICT="test"

BDEPEND="
	doc? ( virtual/texi2dvi )
"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	emake -j1 \
		ORGVERSION="${PV}" \
		datadir="${EPREFIX}${SITEETC}/${PN}"

	use doc && emake -j1 pdf card
}

src_install() {
	emake -j1 \
		ORGVERSION="${PV}" \
		DESTDIR="${D}" \
		ETCDIRS="styles csl $(use odt-schema && echo schema)" \
		lispdir="${EPREFIX}${SITELISP}/${PN}" \
		datadir="${EPREFIX}${SITEETC}/${PN}" \
		infodir="${EPREFIX}/usr/share/info" \
		install

	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc README.org CONTRIBUTE.org etc/ORG-NEWS
	use doc && dodoc doc/org.pdf doc/orgcard.pdf doc/orgguide.pdf

	local DOC_CONTENTS="Org mode has a large variety of run-time dependencies,
		so you may have to install one or more additional packages.
		A non-exhaustive list of these dependencies may be found at
		<http://orgmode.org/worg/org-dependencies.html>."
	readme.gentoo_create_doc
}
