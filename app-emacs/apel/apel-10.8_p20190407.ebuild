# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="A Portable Emacs Library is a library for making portable Emacs Lisp programs"
HOMEPAGE="https://github.com/wanderlust/apel"
GITHUB_SHA1="d146ddbf8818e81d3577d5eee7825d377bec0c73"
SRC_URI="https://github.com/wanderlust/apel/archive/${GITHUB_SHA1}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"

S="${WORKDIR}/${PN}-${GITHUB_SHA1}"

src_prepare() {
	elisp_src_prepare
	cat <<-EOF >>APEL-CFG || die
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
}
