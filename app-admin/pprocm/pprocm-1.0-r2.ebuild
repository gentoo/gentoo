# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="PProcM"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="ncurses-based program to monitor CPU, disk, network and memory usage"
HOMEPAGE="http://www.fusedcreations.com/PProcM/"
SRC_URI="http://www.fusedcreations.com/PProcM/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-perl/POE
	dev-perl/Sys-Statistics-Linux
	dev-perl/IO-Pipely
	dev-lang/perl"

RDEPEND="
	${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS README )

src_install() {
	newbin "${MY_PN}" "${PN}"
	einstalldocs
}
