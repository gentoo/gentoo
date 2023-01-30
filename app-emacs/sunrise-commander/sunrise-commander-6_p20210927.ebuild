# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTICE: Check version of sunrise-commander in it's "Cask" & "sunrise.el".

EAPI=8

COMMIT=16e6df7e86c7a383fb4400fae94af32baf9cb24e
NEED_EMACS=24.3

inherit elisp

DESCRIPTION="Twin-pane file manager for Emacs inspired by Midnight Commander"
HOMEPAGE="https://www.emacswiki.org/emacs/Sunrise_Commander/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
