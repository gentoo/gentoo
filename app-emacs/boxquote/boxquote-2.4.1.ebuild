# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Quote text with a semi-box"
HOMEPAGE="http://www.davep.org/emacs/
	https://github.com/davep/boxquote.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/davep/${PN}.el"
else
	SRC_URI="https://github.com/davep/${PN}.el/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}.el-${PV}"

	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile *.el
	elisp-make-autoload-file
}
