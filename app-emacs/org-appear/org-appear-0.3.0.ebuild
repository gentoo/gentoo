# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Toggle visibility of hidden Org mode element parts upon entering and leaving an element"
HOMEPAGE="https://github.com/awth13/org-appear/"
SRC_URI="https://github.com/awth13/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.org demo.gif )
SITEFILE="50${PN}-gentoo.el"
