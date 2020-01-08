# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="A library to provide basic features about message representation or encoding"
HOMEPAGE="https://github.com/wanderlust/flim"
GITHUB_SHA1="e4bd54fd7d335215b54f7ef27ed974c8cd68d472"
SRC_URI="https://github.com/wanderlust/flim/archive/${GITHUB_SHA1}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 ~ia64 ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"

DEPEND=">=app-emacs/apel-10.8"
RDEPEND="${DEPEND}
	!app-emacs/limit"

S="${WORKDIR}/${PN}-${GITHUB_SHA1}"
SITEFILE="60${PN}-gentoo.el"

src_compile() {
	emake PREFIX="${ED}/usr" \
		LISPDIR="${ED}/${SITELISP}" \
		VERSION_SPECIFIC_LISPDIR="${ED}/${SITELISP}"
}

src_install() {
	emake PREFIX="${ED}/usr" \
		LISPDIR="${ED}/${SITELISP}" \
		VERSION_SPECIFIC_LISPDIR="${ED}/${SITELISP}" install

	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	dodoc FLIM-API.en NEWS VERSION README* ChangeLog
}
