# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="ANSI and xterm-256 color text property translator for GNU Emacs"
HOMEPAGE="https://github.com/atomontage/xterm-color/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/atomontage/${PN}"
else
	SRC_URI="https://github.com/atomontage/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( NEWS.org README.org )
SITEFILE="50${PN}-gentoo.el"
