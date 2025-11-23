# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS=25.2

inherit elisp

DESCRIPTION="JSON-RPC library (GNU ELPA release, also part of Emacs)"
HOMEPAGE="https://elpa.gnu.org/packages/jsonrpc.html"
SRC_URI="https://dev.gentoo.org/~arsen/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

ELISP_REMOVE=jsonrpc-pkg.el
