# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="29.1"

inherit elisp

DESCRIPTION="An IRCv3-compliant IRC client for GNU Emacs"
HOMEPAGE="https://github.com/parenworks/clatter.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/parenworks/${PN}.el"
else
	SRC_URI="https://github.com/parenworks/${PN}.el/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}.el-${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

DOCS=( GUIDE.org README.org )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}

src_test() {
	emake test
}
