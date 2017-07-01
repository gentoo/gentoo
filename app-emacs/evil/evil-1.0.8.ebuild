# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="Extensible vi layer for Emacs"
HOMEPAGE="http://gitorious.org/evil"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-3+ FDL-1.3+"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="test"

RDEPEND=">=app-emacs/undo-tree-0.6.3"
DEPEND="${RDEPEND}
	sys-apps/texinfo"

S="${WORKDIR}/${PN}"
ELISP_REMOVE="evil-pkg.el evil-tests.el"
ELISP_TEXINFO="doc/evil.texi"
SITEFILE="50${PN}-gentoo.el"
DOCS="CHANGES.org"
