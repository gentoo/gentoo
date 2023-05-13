# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Highlight TODO and similar keywords in comments and strings"
HOMEPAGE="https://github.com/tarsius/hl-todo/"
SRC_URI="https://github.com/tarsius/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=app-emacs/compat-29.1.4.0"
BDEPEND="${RDEPEND}"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"
