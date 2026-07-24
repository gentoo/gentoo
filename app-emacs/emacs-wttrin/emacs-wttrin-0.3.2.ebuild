# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="GNU Emacs frontend for wttr.in weather report service"
HOMEPAGE="https://github.com/cjennings/emacs-wttrin/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cjennings/${PN}"
else
	SRC_URI="https://github.com/cjennings/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/xterm-color-1.0
"
BDEPEND="
	${RDEPEND}
"

DOCS=( README.org TESTING.org )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}

src_test() {
	elisp-test-ert ./tests/ \
		-l test-wttrin--add-buffer-instructions.el \
		-l test-wttrin--buffer-cache-refresh.el
}
