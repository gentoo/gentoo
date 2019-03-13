# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib

MY_P=${P/nagios-/}

DESCRIPTION="Nagios plugin to monitor bonding status of network interfaces"
HOMEPAGE="http://folk.uio.no/trondham/software/check_linux_bonding.html"
SRC_URI="http://folk.uio.no/trondham/software/files/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	default

	local nagiosplugindir=/usr/$(get_libdir)/nagios/plugins
	dodir "${nagiosplugindir}"
	exeinto ${nagiosplugindir}
	doexe check_linux_bonding

	dodoc CHANGES
	doman man/check_linux_bonding.8
}
