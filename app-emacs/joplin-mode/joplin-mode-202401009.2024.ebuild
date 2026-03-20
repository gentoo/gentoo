# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

[[ ${PV} == 202401009.2024 ]] && COMMIT=08d68e776eaf46b59f9b00bce0a40e52b7e406c7

inherit elisp

DESCRIPTION="GNU Emacs client for accessing Joplin notes"
HOMEPAGE="https://github.com/cinsk/joplin-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/cinsk/${PN}"
else
	SRC_URI="https://github.com/cinsk/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	app-emacs/markdown-mode
"
BDEPEND="
	${RDEPEND}
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
