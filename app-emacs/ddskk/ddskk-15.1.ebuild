# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
NEED_EMACS="24"

inherit elisp

DESCRIPTION="One Japanese input methods on Emacs"
HOMEPAGE="http://openlab.ring.gr.jp/skk/"
SRC_URI="http://openlab.ring.gr.jp/skk/maintrunk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=""
RDEPEND="|| (
		app-i18n/skk-jisyo
		virtual/skkserv
	)"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	echo "(setq PREFIX \"${ED}/usr\")" >>SKK-CFG
	echo "(setq SKK_LISPDIR \"${ED}/${SITELISP}/${PN}\")" >>SKK-CFG

	echo "(add-to-list 'load-path (expand-file-name \"..\"))" >> nicola/NICOLA-DDSKK-CFG

	eapply "${FILESDIR}"/${P}-skk-mk.patch
	eapply_user

	rm -f skk-lookup.el
	mv {bayesian,tut-code}/*.el .
}

src_compile() {
	emake elc info

	emake -C nicola
}

src_install () {
	local lispdir=${SITELISP}/${PN}
	emake install-elc
	elisp-compile "${ED}"/${lispdir}/skk-setup.el
	rm -f "${ED}"/${lispdir}/leim-list.el
	elisp-site-file-install "${FILESDIR}"/${SITEFILE}

	dodoc ChangeLog* READMEs/README READMEs/{AUTHORS,CODENAME,Contributors,FAQ,NEWS,PROPOSAL,TODO}*
	doinfo doc/skk.info

	local exts=( nicola tut-code bayesian ) d f
	elisp-install ${PN} nicola/*.{el,elc}
	for d in ${exts[@]}; do
		docinto ${d}
		for f in ${d}/{ChangeLog,README}*; do
			[[ -s ${f} ]] && dodoc ${f}
		done
	done
	docinto bayesian
	dodoc bayesian/bskk
}
