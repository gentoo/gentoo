# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="A generic interface for proof assistants"
HOMEPAGE="https://proofgeneral.github.io/"
SRC_URI="https://github.com/ProofGeneral/PG/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ GPL-2 GPL-3+ HPND CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND=">=app-emacs/mmm-mode-0.4.8-r2"
BDEPEND="${RDEPEND}"

S="${WORKDIR}/PG-${PV}"
ELISP_PATCHES="${P}-images-dir.patch
	${P}-desktop.patch"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare
	sed -i -e "s:@SITEETC@:${EPREFIX}${SITEETC}/${PN}:" \
		generic/proof-site.el || die
	sed -i -e '/^OTHER_ELISP/s:contrib/mmm::' Makefile || die
}

src_compile() {
	#emake clean		# remove precompiled lisp files
	emake -j1 compile doc.info EMACS=emacs
}

src_install() {
	emake -j1 install-elisp install-bin install-desktop \
		EMACS=emacs \
		PREFIX="${ED}"/usr \
		ELISP="${ED}${SITELISP}"/${PN} \
		DEST_ELISP="${EPREFIX}${SITELISP}"/${PN}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	# move images out of elisp dir
	mkdir -p "${ED}${SITEETC}"/${PN}/ || die
	mv "${ED}${SITELISP}"/${PN}/images "${ED}${SITEETC}"/${PN}/ || die

	doinfo doc/*.info*
	doman doc/proofgeneral.1
	dodoc AUTHORS BUGS CHANGES COMPATIBILITY FAQ.md INSTALL README.md REGISTER
}

pkg_postinst() {
	elisp-site-regen
	# Already in REGISTER, so no need to install README.gentoo
	elog "Please register your use of Proof General on the web at:"
	elog "  http://proofgeneral.inf.ed.ac.uk/register"
	elog "(see the REGISTER file for more information)"
}
