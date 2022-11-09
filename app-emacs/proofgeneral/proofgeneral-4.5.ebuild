# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit wrapper elisp

DESCRIPTION="A generic interface for proof assistants"
HOMEPAGE="https://proofgeneral.github.io/"
SRC_URI="https://github.com/ProofGeneral/PG/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/PG-${PV}

LICENSE="GPL-2+ GPL-2 GPL-3+ HPND CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-4.4-desktop.patch
	"${FILESDIR}"/${PN}-4.5-paths.patch
)
DOCS=( AUTHORS BUGS CHANGES COMPATIBILITY FAQ.md INSTALL README.md )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed -e "s|@EPREFIX@|${EPREFIX}|" \
		-e "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|" \
		-i generic/proof-site.el || die
}

src_compile() {
	emake compile doc.info
}

src_install() {
	emake install-elisp install-bin install-desktop \
		PREFIX="${ED}"/usr \
		ELISP="${ED}${SITELISP}"/${PN} \
		DEST_ELISP="${EPREFIX}${SITELISP}"/${PN}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	# move images out of elisp dir
	mkdir -p "${ED}${SITEETC}"/${PN}/ || die
	mv "${ED}${SITELISP}"/${PN}/images "${ED}${SITEETC}"/${PN}/ || die

	# Create missing script, loosely translated from 4.4 version
	make_wrapper ${PN} "${EMACS} \
		-eval '(load \"${SITELISP}/${PN}/generic/proof-site.el\")' \
		-f proofgeneral \
		-f proof-splash-display-screen"

	doinfo doc/*.info*
	doman doc/${PN}.1
	einstalldocs
}
