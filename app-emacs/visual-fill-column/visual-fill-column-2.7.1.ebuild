# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="GNU Emacs mode for wrapping visual-line-mode buffers at fill-column"
HOMEPAGE="https://codeberg.org/joostkremers/visual-fill-column/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://codeberg.org/joostkremers/${PN}"
else
	SRC_URI="https://codeberg.org/joostkremers/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert ./test/

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
