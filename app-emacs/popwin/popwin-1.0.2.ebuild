# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Popup window manager for Emacs"
HOMEPAGE="https://github.com/emacsorphanage/popwin"
SRC_URI="https://github.com/emacsorphanage/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"		# "make test" starts Emacs in non-batch mode

SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"
