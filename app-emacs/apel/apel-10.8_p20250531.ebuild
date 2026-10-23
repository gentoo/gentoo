# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="A Portable Emacs Library is a library for making portable Emacs Lisp programs"
HOMEPAGE="https://github.com/wanderlust/apel"
GITHUB_SHA1="2383abfd3a27c094ae9095b05103167cf810379b"
SRC_URI="https://github.com/wanderlust/${PN}/archive/${GITHUB_SHA1}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${GITHUB_SHA1}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"

SITEFILE="50apel-gentoo.el"

src_prepare() {
	elisp_src_prepare
	cat <<-EOF >>APEL-CFG || die
	(setq APEL_PREFIX "apel")
	(setq EMU_PREFIX "apel")
	EOF
}

src_compile() {
	default
}

src_install() {
	emake PREFIX="${ED}/usr" \
		LISPDIR="${ED}/${SITELISP}" \
		VERSION_SPECIFIC_LISPDIR="${ED}/${SITELISP}" \
		install
	elisp-make-site-file "${SITEFILE}"
	dodoc ChangeLog* README*
}
