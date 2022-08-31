# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS=25

inherit elisp

DESCRIPTION="Edit text area on Chrome with Emacs using Atomic Chrome"
HOMEPAGE="https://github.com/alpha22jp/atomic-chrome"
SRC_URI="https://github.com/alpha22jp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-emacs/websocket"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"
