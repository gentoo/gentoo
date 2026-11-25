# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="29.1"

inherit elisp

DESCRIPTION="Work with Git forges from the comfort of Magit"
HOMEPAGE="https://magit.vc/
	https://github.com/magit/forge/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/magit/${PN}"
else
	SRC_URI="https://github.com/magit/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64"
fi

S="${WORKDIR}/${P}/lisp"

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/closql-2.4
	>=app-emacs/compat-30.1.0.1
	>=app-emacs/cond-let-1.0.0
	>=app-emacs/emacsql-4.3.6
	>=app-emacs/ghub-5.2.0
	>=app-emacs/llama-1.0.4
	>=app-emacs/magit-4.5.0
	>=app-emacs/markdown-mode-2.8
	>=app-emacs/transient-0.13
	>=app-emacs/yaml-1.2.3
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"

DOCS=( ../README.org )
ELISP_TEXINFO="../docs/*.texi"
SITEFILE="50${PN}-gentoo.el"
