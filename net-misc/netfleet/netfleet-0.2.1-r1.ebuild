# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-r2

DESCRIPTION="Qt4 cross-platform multi-threaded download utility"
HOMEPAGE="http://qt-apps.org/content/show.php/?content=103312"
SRC_URI="https://netfleet.googlecode.com/files/${PN}_${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:4[ssl]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
