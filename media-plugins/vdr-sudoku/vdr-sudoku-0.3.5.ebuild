# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vdr-plugin-2

VERSION="280" # every bump, new version

DESCRIPTION="VDR plugin: to generate and solve Number Place puzzles, so called Sudokus"
HOMEPAGE="http://projects.vdr-developer.org/projects/show/plg-sudoku"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=media-video/vdr-1.6.0"
RDEPEND="${DEPEND}"
