# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="PProcM"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="ncurses-based program to monitor CPU, disk, network and memory usage"
HOMEPAGE="https://github.com/ZachGoldberg/Perl-Proc-Monitor-PProcM"
SRC_URI="http://www.fusedcreations.com/PProcM/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-lang/perl
	dev-perl/IO-Pipely
	dev-perl/POE
	dev-perl/Sys-Statistics-Linux
"

src_install() {
	newbin "${MY_PN}" "${PN}"
	einstalldocs
}
