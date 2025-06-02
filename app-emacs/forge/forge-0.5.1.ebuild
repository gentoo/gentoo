# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="29.1"

inherit elisp

DESCRIPTION="Work with Git forges from the comfort of Magit"
HOMEPAGE="https://magit.vc/
	https://github.com/magit/forge/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/magit/${PN}"
else
	SRC_URI="https://github.com/magit/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64"
fi

S="${WORKDIR}/${P}/lisp"

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-30.1.0.0
	>=app-emacs/ghub-4.1.1
	>=app-emacs/magit-4.1.3
	>=app-emacs/transient-0.9.0
	app-emacs/closql
	app-emacs/dash
	app-emacs/emacsql
	app-emacs/llama
	app-emacs/markdown-mode
	app-emacs/yaml
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"

DOCS=( ../README.org )
ELISP_TEXINFO="../docs/*.texi"
SITEFILE="50${PN}-gentoo.el"
