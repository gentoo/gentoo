# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="a backup program for disk array for home media centers"
HOMEPAGE="http://snapraid.sourceforge.net/"
SRC_URI="https://github.com/amadvance/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DOCS=( "AUTHORS" "HISTORY" "README" "TODO" "snapraid.conf.example" )
