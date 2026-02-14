# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Use the Emacsclient as the \$EDITOR of child processes"
HOMEPAGE="https://magit.vc/manual/with-editor/
	https://github.com/magit/with-editor/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/magit/${PN}"
else
	SRC_URI="https://github.com/magit/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="amd64 arm arm64 ppc64 ~riscv x86"
fi

S="${WORKDIR}/${P}/lisp"

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/compat
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"

DOCS=( ../README.org "../docs/${PN}.org" )
ELISP_TEXINFO="../docs/*.texi"
SITEFILE="50${PN}-gentoo.el"
