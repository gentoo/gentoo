# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="A Portable Emacs Library is a library for making portable Emacs Lisp programs"
HOMEPAGE="https://github.com/wanderlust/apel"
GITHUB_SHA1="82eb2325bd149dc57b43a9ce9402c6c6183e4052"
SRC_URI="https://github.com/wanderlust/${PN}/archive/${GITHUB_SHA1}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${GITHUB_SHA1}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

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
