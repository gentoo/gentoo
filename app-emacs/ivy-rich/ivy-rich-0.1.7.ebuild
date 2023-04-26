# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="More friendly interface for ivy"
HOMEPAGE="https://github.com/Yevgnen/ivy-rich/"
SRC_URI="https://github.com/Yevgnen/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-emacs/ivy"
BDEPEND="${RDEPEND}"

DOCS=( README.org screenshots.org screenshots )
SITEFILE="50${PN}-gentoo.el"
