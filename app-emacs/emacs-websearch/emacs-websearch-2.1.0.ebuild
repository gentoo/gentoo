# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.4

inherit elisp

DESCRIPTION="Query search engines from Emacs"
HOMEPAGE="https://gitlab.com/xgqt/emacs-websearch/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/xgqt/${PN}.git"
else
	SRC_URI="https://gitlab.com/xgqt/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

DOCS=( README.md logo.png )

src_install() {
	elisp_src_install
	elisp-site-file-install "${S}"/extras/gentoo/50websearch-gentoo.el
}
