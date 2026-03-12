# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ "${PV}" == *_p20250401 ]] && COMMIT="90b72cd2c9bc4506f531bcdcd73fa2530d9f4f7c"

inherit elisp

DESCRIPTION="Major mode for the Elm programming language"
HOMEPAGE="https://github.com/jcollard/elm-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/jcollard/${PN}"
else
	SRC_URI="https://github.com/jcollard/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/f
	app-emacs/reformatter
	app-emacs/s
"
BDEPEND="
	${RDEPEND}
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	sed -i elm-tags.el -e "s|(f-dirname load-file-name)|\"${SITEETC}/${PN}\"|g" || die
	elisp_src_prepare
}

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}

src_install() {
	elisp_src_install
	insinto "${SITEETC}/${PN}"
	doins elm.tags
}
