# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1
inherit elisp

DESCRIPTION="Work with Git forges from the comfort of Magit"
HOMEPAGE="https://magit.vc/
	https://github.com/magit/forge/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/magit/${PN}.git"
else
	SRC_URI="https://github.com/magit/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64"
fi

S="${WORKDIR}/${P}/lisp"

LICENSE="GPL-3+"
SLOT="0"

DOCS=( ../README.org )
ELISP_TEXINFO="../docs/*.texi"
SITEFILE="50${PN}-gentoo.el"

RDEPEND="
	app-emacs/compat
	app-emacs/closql
	app-emacs/dash
	app-emacs/emacsql
	>=app-emacs/ghub-4.1.1
	>=app-emacs/magit-4.1.1
	app-emacs/markdown-mode
	>=app-emacs/transient-0.7.6
	app-emacs/yaml
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"
