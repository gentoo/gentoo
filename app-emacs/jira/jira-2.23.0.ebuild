# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Interface to Jira, visualize and manipulate Jira issues from GNU Emacs"
HOMEPAGE="https://github.com/unmonoqueteclea/jira.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/unmonoqueteclea/${PN}.el"
else
	SRC_URI="https://github.com/unmonoqueteclea/${PN}.el/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}.el-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/magit-4.2.0
	>=app-emacs/request-0.3.0
	>=app-emacs/tablist-1.0
	>=app-emacs/transient-0.8.3
"
BDEPEND="
	${RDEPEND}
"

DOCS=( readme.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert ./test/

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
