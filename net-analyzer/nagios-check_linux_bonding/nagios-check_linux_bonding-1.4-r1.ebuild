# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="fde23cba225870ceb1162d918a6307c608e654a5"
MY_P="${P/nagios-/}"

DESCRIPTION="Nagios plugin to monitor bonding status of network interfaces"
HOMEPAGE="https://github.com/glynastill/check_linux_bonding-1.4"
SRC_URI="https://github.com/glynastill/${MY_P}/archive/${EGIT_COMMIT}.tar.gz -> ${MY_P}.gh.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}-${EGIT_COMMIT}

src_install() {
	default

	local nagiosplugindir=/usr/$(get_libdir)/nagios/plugins
	dodir "${nagiosplugindir}"
	exeinto ${nagiosplugindir}
	doexe check_linux_bonding

	dodoc CHANGES
	doman man/check_linux_bonding.8
}
