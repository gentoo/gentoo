# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp edo

DESCRIPTION="A collection of yasnippet snippets for many languages"
HOMEPAGE="https://github.com/AndreaCrotti/yasnippet-snippets"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/AndreaCrotti/${PN}.git"
else
	SRC_URI="https://github.com/AndreaCrotti/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/yasnippet
"
BDEPEND="
	${RDEPEND}
"

PATCHES=( "${FILESDIR}/${PN}-dir.patch" )

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|" -i "${PN}.el" || die
}

src_compile() {
	elisp_src_compile

	edo ${EMACS} ${EMACSFLAGS} \
		--eval "(require 'yasnippet)" \
		--eval "(yas-compile-directory \"${S}/snippets\")"
}

src_install() {
	elisp_src_install

	insinto "${SITEETC}/${PN}"
	doins -r snippets
}
