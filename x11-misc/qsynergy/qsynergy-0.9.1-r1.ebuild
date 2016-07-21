# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-r2

DESCRIPTION="A comprehensive and easy to use graphical front end for Synergy"
HOMEPAGE="http://www.volker-lanz.de/en/software/qsynergy/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-qt/qtgui:4"
RDEPEND="${DEPEND}
	x11-misc/synergy"

DOCS=( README )
