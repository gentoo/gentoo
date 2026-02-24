# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="30.1"
inherit elisp

DESCRIPTION="Manage Forgejo PRs with AGit-Flow in Emacs"
HOMEPAGE="https://codeberg.org/halvin/agitjo"
SRC_URI="https://codeberg.org/halvin/agitjo/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( CHANGELOG.org README.org )
SITEFILE="50${PN}-gentoo.el"

RDEPEND="
	app-emacs/magit
	app-emacs/markdown-mode
	app-emacs/transient
"
BDEPEND="${RDEPEND}"
