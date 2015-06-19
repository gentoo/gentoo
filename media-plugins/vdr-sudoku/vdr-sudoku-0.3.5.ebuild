# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-sudoku/vdr-sudoku-0.3.5.ebuild,v 1.6 2014/08/10 21:06:54 slyfox Exp $

EAPI="4"

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
