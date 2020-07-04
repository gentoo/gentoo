# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

NEED_EMACS=24
inherit elisp

DESCRIPTION="A GNU Emacs major mode for Meson build-system files"
HOMEPAGE="https://github.com/wentasah/meson-mode"
SRC_URI="https://github.com/wentasah/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( README.md )

SITEFILE="50${PN}-gentoo.el"
