# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Qt GUI for git repositories"
HOMEPAGE="http://libre.tibirna.org/projects/qgit"
SRC_URI="https://github.com/tibirna/qgit/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}
	dev-vcs/git
	!dev-vcs/qgit:2
"

S=${WORKDIR}/${PN}-${P}
