# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="PProcM"
GIT_COMMIT="98ca63f43afb9ec8491cceb81f62850ff00379e0"

DESCRIPTION="Ncurses-based program to monitor CPU, disk, network and memory usage"
HOMEPAGE="https://github.com/ZachGoldberg/Perl-Proc-Monitor-PProcM/"
SRC_URI="https://github.com/ZachGoldberg/Perl-Proc-Monitor-PProcM/archive/${GIT_COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/Perl-Proc-Monitor-PProcM-${GIT_COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

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
