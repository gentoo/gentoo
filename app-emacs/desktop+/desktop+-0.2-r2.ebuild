# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="desktop+ extends standard desktop module"
HOMEPAGE="https://github.com/ffevotte/desktop-plus"
SRC_URI="https://github.com/ffevotte/desktop-plus/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

RDEPEND="app-emacs/dash
	app-emacs/f"
BDEPEND="${RDEPEND}"

S="${WORKDIR}/desktop-plus-${PV}"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"
