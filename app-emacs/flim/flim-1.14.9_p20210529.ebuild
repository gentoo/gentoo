# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS=24.5

inherit elisp

DESCRIPTION="A library to provide basic features about message representation or encoding"
HOMEPAGE="https://github.com/wanderlust/flim"
GITHUB_SHA1="02735dede6603987e8309a76d0bc7a9ff9a5a227"
SRC_URI="https://github.com/wanderlust/${PN}/archive/${GITHUB_SHA1}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${GITHUB_SHA1}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

RDEPEND=">=app-emacs/apel-10.8"
DEPEND="${RDEPEND}"

SITEFILE="60${PN}-gentoo.el"

src_compile() {
	default
}

src_install() {
	emake PREFIX="${ED}/usr" \
		LISPDIR="${ED}/${SITELISP}" \
		VERSION_SPECIFIC_LISPDIR="${ED}/${SITELISP}" install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc FLIM-API.en NEWS VERSION README* ChangeLog*
}
