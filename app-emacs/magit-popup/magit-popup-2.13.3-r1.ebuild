# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Define prefix-infix-suffix command combos"
HOMEPAGE="https://magit.vc/manual/magit-popup/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/magit/${PN}"
else
	SRC_URI="https://github.com/magit/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/dash
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"

DOCS=( README.md )
ELISP_TEXINFO="*.texi"
SITEFILE="50${PN}-gentoo.el"
