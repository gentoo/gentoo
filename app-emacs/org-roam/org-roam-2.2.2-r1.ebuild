# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1
inherit elisp

DESCRIPTION="Rudimentary Roam replica with Org-mode"
HOMEPAGE="https://github.com/org-roam/org-roam"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="
		https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	"

	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/dash
	app-emacs/magit
	app-emacs/emacsql[sqlite]
"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp-make-autoload-file
	elisp_src_install
}
