# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MY_P="PProcM-"${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="a ncurses which monitors the CPU, disk, network and memory usage"
HOMEPAGE="http://www.fusedcreations.com/PProcM/"
SRC_URI="http://www.fusedcreations.com/PProcM/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-perl/POE
	dev-perl/Sys-Statistics-Linux
	dev-lang/perl"

RDEPEND="dev-perl/IO-Pipely"

src_install() {
	dobin PProcM || die "dobin failed"
	dodoc AUTHORS README || die "dodoc failed"
}
