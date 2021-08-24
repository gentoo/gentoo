# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS=24.5

inherit elisp

DESCRIPTION="A Portable Emacs Library is a library for making portable Emacs Lisp programs"
HOMEPAGE="https://github.com/wanderlust/apel"
GITHUB_SHA1="4e3269b6e702db2dba48cf560563ac883e81e3bf"
SRC_URI="https://github.com/wanderlust/${PN}/archive/${GITHUB_SHA1}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${GITHUB_SHA1}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

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
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc ChangeLog* README*
}
