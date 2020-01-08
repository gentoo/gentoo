# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="A library to provide MIME feature for GNU Emacs"
HOMEPAGE="https://github.com/wanderlust/semi"
GITHUB_SHA1="4cf114c95fb49ad75eb6916f678b45b04bad8122"
SRC_URI="https://github.com/wanderlust/semi/archive/${GITHUB_SHA1}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 ~ia64 ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="l10n_ja"

DEPEND=">=app-emacs/apel-10.8
	>=app-emacs/flim-1.14.9"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${GITHUB_SHA1}"
ELISP_PATCHES="${PN}-info.patch"
SITEFILE="65${PN}-gentoo.el"

src_compile() {
	emake PREFIX="${ED}"/usr \
		LISPDIR="${ED}/${SITELISP}" \
		VERSION_SPECIFIC_LISPDIR="${ED}/${SITELISP}"

	${EMACS} ${EMACSFLAGS} --visit mime-ui-en.texi -f texi2info || die
	if use l10n_ja; then
		${EMACS} ${EMACSFLAGS} \
			--eval "(set-default-coding-systems 'iso-2022-jp)" \
			--visit mime-ui-ja.texi -f texi2info || die
	fi
}

src_install() {
	emake PREFIX="${ED}/usr" \
		LISPDIR="${ED}/${SITELISP}" \
		VERSION_SPECIFIC_LISPDIR="${ED}/${SITELISP}" install

	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	doinfo mime-ui-en.info
	dodoc README.en ChangeLog VERSION NEWS
	if use l10n_ja; then
		doinfo mime-ui-ja.info
		dodoc README.ja
	fi
}
