# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Superior code reading and auto-completion with pluggable backends for GNU Emacs"
HOMEPAGE="https://github.com/universal-ctags/citre/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/universal-ctags/${PN}"
else
	SRC_URI="https://github.com/universal-ctags/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	dev-util/global
	dev-util/ctags
"
BDEPEND="
	${RDEPEND}
"

DOCS=( CHANGELOG.md README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	emake test-common
	emake test-tags
	emake test-global
}

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}

src_install() {
	elisp_src_install
	dodoc -r ./docs/{developer,user}-manual/
	docompress -x /usr/share/doc/${PF}/{developer,user}-manual/
}
