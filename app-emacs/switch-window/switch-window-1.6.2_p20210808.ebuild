# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=8d9fe251d8d38b223d643df975876356ddfc1b98
NEED_EMACS=24

inherit elisp

DESCRIPTION="Offer a customizable visual way to choose a window to switch to"
HOMEPAGE="https://github.com/dimitri/switch-window/"
SRC_URI="https://github.com/dimitri/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md snapshots )
SITEFILE="50${PN}-gentoo.el"
