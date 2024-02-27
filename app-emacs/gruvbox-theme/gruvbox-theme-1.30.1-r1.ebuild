# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1

inherit elisp

DESCRIPTION="Gruvbox is a retro groove color scheme, now in Emacs"
HOMEPAGE="https://github.com/greduan/emacs-theme-gruvbox/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/greduan/emacs-theme-gruvbox.git"
else
	SRC_URI="https://github.com/greduan/emacs-theme-gruvbox/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/emacs-theme-gruvbox-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	>=app-emacs/autothemer-0.2
"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"
