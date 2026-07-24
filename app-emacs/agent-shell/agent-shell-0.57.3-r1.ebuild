# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="29.1"

inherit elisp

DESCRIPTION="Many native agentic integrations inside GNU Emacs"
HOMEPAGE="https://github.com/xenodium/agent-shell/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/xenodium/${PN}"
else
	SRC_URI="https://github.com/xenodium/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/acp-0.12.2
	>=app-emacs/shell-maker-0.93.3
"
BDEPEND="
	${RDEPEND}
"

DOCS=( CONTRIBUTING.org README.org blog-post.org )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}

src_test() {
	local test_file=""
	for test_file in ./tests/*-tests.el ; do
		elisp-test-ert ./tests/ -l "${test_file}"
	done
}
