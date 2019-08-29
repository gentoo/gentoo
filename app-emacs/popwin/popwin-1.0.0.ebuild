# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Popup window manager for Emacs"
HOMEPAGE="https://github.com/m2ym/popwin-el"
SRC_URI="https://github.com/m2ym/${PN}-el/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"		# "make test" starts Emacs in non-batch mode

S="${WORKDIR}/${PN}-el-${PV}"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"
