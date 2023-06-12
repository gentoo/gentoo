# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1
inherit elisp

DESCRIPTION="Gruvbox is a retro groove color scheme, now in Emacs"
HOMEPAGE="https://github.com/greduan/emacs-theme-gruvbox/"

SRC_URI="https://github.com/greduan/emacs-theme-gruvbox/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/emacs-theme-gruvbox-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=app-emacs/autothemer-0.2
"
DEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"
