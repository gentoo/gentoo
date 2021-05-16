# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp readme.gentoo-r1

DESCRIPTION="Source code browser for Emacs"
HOMEPAGE="http://ecb.sourceforge.net/"
# snapshot of https://github.com/ecb-home/ecb.git, created with "make distrib"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="java"

RDEPEND="java? ( app-emacs/jde )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${PV%_*}"
SITEFILE="70${PN}-gentoo.el"
DOC_CONTENTS="ECB is autoloaded in site-gentoo.el. Add the line
	\n\t(require 'ecb)
	\nto your ~/.emacs file to enable all features on Emacs startup."

src_prepare() {
	eapply "${FILESDIR}"/${PN}-2.32-gentoo.patch
	sed -i -e "s:@PF@:${PF}:" ecb-help.el || die "sed failed"
	eapply_user
}

src_compile() {
	local loadpath
	use java && loadpath="${EPREFIX}${SITELISP}"/{elib,jde,jde/lisp}
	emake LOADPATH="${loadpath}"
}

src_install() {
	elisp_src_install

	insinto "${SITEETC}/${PN}"
	doins -r ecb-images

	doinfo info-help/ecb.info*
	dodoc NEWS README RELEASE_NOTES
	docinto html
	dodoc html-help/*.html
}
