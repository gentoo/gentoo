# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/ecb/ecb-2.41_pre20140215-r1.ebuild,v 1.6 2014/12/29 13:53:21 blueness Exp $

EAPI=5

inherit readme.gentoo elisp eutils

DESCRIPTION="Source code browser for Emacs"
HOMEPAGE="http://ecb.sourceforge.net/"
# snapshot of https://github.com/alexott/ecb.git, created with "make distrib"
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="java"

DEPEND="!!<app-emacs/cedet-2.0
	java? ( app-emacs/jde )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${PV%_*}"
SITEFILE="70${PN}-gentoo.el"
DOC_CONTENTS="ECB is autoloaded in site-gentoo.el. Add the line
	\n\t(require 'ecb)
	\nto your ~/.emacs file to enable all features on Emacs startup."

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.32-gentoo.patch"
	sed -i -e "s:@PF@:${PF}:" ecb-help.el || die "sed failed"
}

src_compile() {
	local loadpath="" sl=${EPREFIX}${SITELISP}
	if use java; then
		loadpath="${sl}/elib ${sl}/jde ${sl}/jde/lisp"
	fi

	emake LOADPATH="${loadpath}"
}

src_install() {
	elisp_src_install

	insinto "${SITEETC}/${PN}"
	doins -r ecb-images

	doinfo info-help/ecb.info*
	dohtml html-help/*.html
	dodoc NEWS README RELEASE_NOTES
}
