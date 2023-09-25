# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="A library to provide basic features about message representation or encoding"
HOMEPAGE="https://github.com/wanderlust/flim"
GITHUB_SHA1="80b8121f05a5a0d7fcfe3e54085467a646dd2028"
SRC_URI="https://github.com/wanderlust/${PN}/archive/${GITHUB_SHA1}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${GITHUB_SHA1}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND=">=app-emacs/apel-10.8"
DEPEND="${RDEPEND}"

SITEFILE="60${PN}-gentoo.el"

src_compile() {
	emake PACKAGE_LISPDIR="NONE"
}

src_install() {
	emake PREFIX="${ED}/usr" \
		LISPDIR="${ED}/${SITELISP}" \
		PACKAGE_LISPDIR="NONE" \
		VERSION_SPECIFIC_LISPDIR="${ED}/${SITELISP}" install
	elisp-make-site-file "${SITEFILE}"
	dodoc FLIM-API.en NEWS VERSION README* ChangeLog*
}
