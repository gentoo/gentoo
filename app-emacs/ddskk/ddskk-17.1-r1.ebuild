# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30"
NEED_EMACS="24.3"

inherit elisp ruby-single vcs-snapshot

DESCRIPTION="One Japanese input methods on Emacs"
HOMEPAGE="http://openlab.ring.gr.jp/skk/"
SRC_URI="https://github.com/skk-dev/${PN}/archive/${P}_Neppu.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="ruby"
RESTRICT="test"

RDEPEND="|| (
		app-i18n/skk-jisyo
		virtual/skkserv
	)
	ruby? ( ${RUBY_DEPS} )"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	echo "(add-to-list 'load-path (expand-file-name \"..\"))" \
		 >>nicola/NICOLA-DDSKK-CFG || die

	default

	rm -f skk-lookup.el || die
	if use ruby; then
		cp bayesian/*.el . || die
	fi
	cp tut-code/*.el . || die
}

src_compile() {
	emake elc info
	emake -C nicola
}

src_install() {
	local lispdir="${SITELISP}/${PN}"

	echo "(setq PREFIX \"${ED}/usr\")" >>SKK-CFG || die
	echo "(setq SKK_LISPDIR \"${ED}${lispdir}\")" >>SKK-CFG || die

	emake install-elc
	elisp-compile "${ED}${lispdir}"/skk-setup.el
	rm -f "${ED}${lispdir}"/leim-list.el || die
	elisp-site-file-install "${FILESDIR}"/${SITEFILE}

	doinfo doc/skk.info
	dodoc ChangeLog* README.md \
		  READMEs/{AUTHORS,CODENAME,Contributors,FAQ,NEWS,PROPOSAL,TODO}*

	local exts=( nicola tut-code ) d f
	elisp-install ${PN} nicola/*.{el,elc}

	if use ruby; then
		dobin bayesian/bskk
		exts+=( bayesian )
	fi

	for d in ${exts[@]}; do
		docinto ${d}
		for f in ${d}/{ChangeLog,README}*; do
			[[ -s ${f} ]] && dodoc ${f}
		done
	done
}
