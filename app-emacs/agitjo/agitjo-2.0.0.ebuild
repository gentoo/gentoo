# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="30.1"

inherit elisp

DESCRIPTION="Manage Forgejo PRs with AGit-Flow in Emacs"
HOMEPAGE="https://codeberg.org/halvin/agitjo/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://codeberg.org/halvin/${PN}"
else
	SRC_URI="https://codeberg.org/halvin/agitjo/archive/v${PV}.tar.gz
		-> ${P}.codeberg.tar.gz"
	S="${WORKDIR}/${PN}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( CHANGELOG.org README.org )
SITEFILE="50${PN}-gentoo.el"

RDEPEND="
	>=app-emacs/magit-4.3.8
	>=app-emacs/markdown-mode-2.7
	>=app-emacs/transient-0.9.1
"
BDEPEND="
	${RDEPEND}
"
