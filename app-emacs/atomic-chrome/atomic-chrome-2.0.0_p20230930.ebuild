# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

COMMIT="072a137a19d7e6a300ca3e87c0e142a7f4ccb5fb"
DESCRIPTION="Edit text area on Chrome with Emacs using Atomic Chrome"
HOMEPAGE="https://github.com/alpha22jp/atomic-chrome"
SRC_URI="https://github.com/alpha22jp/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-emacs/websocket"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"
