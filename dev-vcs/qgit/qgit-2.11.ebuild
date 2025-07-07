# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Qt GUI for git repositories"
HOMEPAGE="https://github.com/tibirna/qgit"
SRC_URI="https://github.com/tibirna/qgit/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

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
"

DOCS=( README.adoc )
