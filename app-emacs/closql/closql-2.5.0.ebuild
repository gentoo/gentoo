# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="28.1"

inherit elisp

DESCRIPTION="Store EIEIO objects using EmacSQL"
HOMEPAGE="https://github.com/magit/closql/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/magit/${PN}"
else
	SRC_URI="https://github.com/magit/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-31.0
	>=app-emacs/cond-let-1.1
	>=app-emacs/emacsql-4.4
	>=app-emacs/llama-1.0
"
BDEPEND="
	${RDEPEND}
"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"
