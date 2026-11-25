# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp unpacker

DESCRIPTION="State machine library"
HOMEPAGE="https://elpa.gnu.org/packages/fsm.html"
SRC_URI="https://elpa.gnu.org/packages/${P}.tar.lz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

ELISP_REMOVE="${PN}-pkg.el"
SITEFILE="50${PN}-gentoo.el"
