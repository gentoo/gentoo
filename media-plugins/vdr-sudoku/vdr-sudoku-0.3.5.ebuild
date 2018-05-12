# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vdr-plugin-2

VERSION="280" # every bump, new version

DESCRIPTION="VDR plugin: to generate and solve Number Place puzzles, so called Sudokus"
HOMEPAGE="https://projects.vdr-developer.org/projects/plg-sudoku"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=media-video/vdr-1.6.0"
RDEPEND="${DEPEND}"
