# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp readme.gentoo-r1

DESCRIPTION="An Emacs mode for notes and project planning"
HOMEPAGE="https://orgmode.org/"

if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://git.savannah.gnu.org/git/emacs/${PN}"
	EGIT_CHECKOUT_DIR="${WORKDIR}/org"
	S="${WORKDIR}/org"
else
	# git archive --prefix=${P}/ release_${PV} | xz > ${P}.tar.xz
	SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 ppc ~riscv x86"
fi

LICENSE="GPL-3+ FDL-1.3+ CC-BY-SA-3.0 odt-schema? ( OASIS-Open )"
SLOT="0"
IUSE="doc odt-schema"

BDEPEND="
	doc? (
		virtual/texi2dvi
	)
"

DOCS=( README.org CONTRIBUTE.org etc/ORG-NEWS )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	# Remove failing tests.
	rm ./testing/lisp/test-{ob{,-exp,-tangle,-shell},org{,-clock}}.el \
		|| die "failed to remove some test files"
}

src_configure() {
	elisp_src_configure

	if use doc ; then
		DOCS+=( doc/org.pdf doc/orgcard.pdf doc/orgguide.pdf )
	fi

	EMAKEARGS=(
		ORGVERSION="${PV}"
		ETCDIRS="styles csl $(usev odt-schema schema)"
		lispdir="${EPREFIX}${SITELISP}/${PN}"
		datadir="${EPREFIX}${SITEETC}/${PN}"
		infodir="${EPREFIX}/usr/share/info"
	)
}

src_compile() {
	emake -j1 "${EMAKEARGS[@]}"

	if use doc ; then
		emake -j1 pdf
		emake -j1 card
	fi
}

src_test() {
	local -x LANG="C"

	emake -j1 "${EMAKEARGS[@]}" TEST_NO_AUTOCLEAN="TRUE" test-dirty
}

src_install() {
	emake -j1 "${EMAKEARGS[@]}" DESTDIR="${D}" install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	einstalldocs

	local DOC_CONTENTS="Org mode has a large variety of run-time dependencies,
		so you may have to install one or more additional packages.
		A non-exhaustive list of these dependencies may be found at
		<http://orgmode.org/worg/org-dependencies.html>."
	readme.gentoo_create_doc
}
