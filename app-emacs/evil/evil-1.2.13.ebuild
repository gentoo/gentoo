# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp

DESCRIPTION="Extensible vi layer for Emacs"
HOMEPAGE="https://github.com/emacs-evil/evil"
SRC_URI="https://github.com/emacs-evil/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+ FDL-1.3+"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="test"

RDEPEND=">=app-emacs/undo-tree-0.6.3"
DEPEND="${RDEPEND}
	sys-apps/texinfo"

ELISP_REMOVE="evil-pkg.el evil-tests.el evil-test-helpers.el"
ELISP_TEXINFO="doc/evil.texi"
SITEFILE="50${PN}-gentoo.el"
DOCS="CHANGES.org CONTRIBUTING.md README.md"
