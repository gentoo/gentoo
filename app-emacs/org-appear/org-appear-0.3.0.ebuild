# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Toggle Org mode element visibility upon entering and leaving"
HOMEPAGE="https://github.com/awth13/org-appear/"
SRC_URI="https://github.com/awth13/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

DOCS=( README.org demo.gif )
SITEFILE="50${PN}-gentoo.el"
