# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Extensible vi layer for Emacs"
HOMEPAGE="https://github.com/emacs-evil/evil"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacs-evil/evil.git"
else
	SRC_URI="https://github.com/emacs-evil/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~arm64 x86"
fi

LICENSE="GPL-3+ FDL-1.3+"
SLOT="0"
RESTRICT="test"

RDEPEND="
	>=app-emacs/undo-tree-0.6.3
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"

ELISP_REMOVE="
	evil-pkg.el
	evil-tests.el
	evil-test-helpers.el
"

DOCS="CHANGES.org CONTRIBUTING.md README.md"
ELISP_TEXINFO="doc/build/texinfo/evil.texi"
SITEFILE="50${PN}-gentoo.el"
