# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit elisp

DESCRIPTION="A Portable Emacs Library is a library for making portable Emacs Lisp programs"
HOMEPAGE="http://cvs.m17n.org/elisp/APEL/"
SRC_URI="ftp://ftp.jpl.org/pub/elisp/apel/${P}.tar.gz
	https://dev.gentoo.org/~gienah/2big4tree/app-emacs/${PN}/${PN}-10.8-030_Use-new-style-backquotes.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

ELISP_PATCHES="${PN}-10.8-020_Prevent-fontset-error.patch
	${PN}-10.8-030_Use-new-style-backquotes.patch
	${PN}-10.8-010_ikazuhiro.patch
	${PN}-10.8-040_make-temp-file-for-Emacs-24.3.50.patch"

src_prepare() {
	elisp_src_prepare
	cat <<-EOF >> APEL-CFG
	(setq APEL_PREFIX "apel")
	(setq EMU_PREFIX "apel")
	EOF
}

src_compile() {
	emake PREFIX="${ED}/usr" \
		LISPDIR="${ED}/${SITELISP}" \
		VERSION_SPECIFIC_LISPDIR="${ED}/${SITELISP}"
}

src_install() {
	emake PREFIX="${ED}/usr" \
		LISPDIR="${ED}/${SITELISP}" \
		VERSION_SPECIFIC_LISPDIR="${ED}/${SITELISP}" \
		install
	elisp-site-file-install "${FILESDIR}/50apel-gentoo.el"
	dodoc ChangeLog README*
}

pkg_postinst() {
	elisp-site-regen
	elog "See the README.en file in /usr/share/doc/${PF} for tips"
	elog "on how to customize this package."
	elog "And you need to rebuild packages depending on ${PN}."
}
