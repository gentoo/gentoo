# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Emacs major mode for devicetree sources"
HOMEPAGE="https://github.com/bgamari/dts-mode
	https://elpa.gnu.org/packages/dts-mode.html"
# taken from https://elpa.gnu.org/packages/${P}.tar
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ELISP_REMOVE="dts-mode-pkg.el"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.mkd"
