# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

MY_PN="SleepProxyClient"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"
SRC_URI="https://codeload.github.com/awein/${MY_PN}/tar.gz/v${PV} -> ${P}.tar.gz"

DESCRIPTION="A SleepProxyClient implementation"
HOMEPAGE="https://github.com/awein/SleepProxyClient"
LICENSE="GPL-3"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="examples pm-utils"

RDEPEND="
	dev-python/dnspython[${PYTHON_USEDEP}]
	dev-python/netifaces[${PYTHON_USEDEP}]
	net-dns/avahi
	examples? ( sys-devel/bc )
	pm-utils? ( sys-power/pm-utils )
"

DOCS=( README.md )
PATCHES=(
	"${FILESDIR}"/${P}-find-config.patch
	"${FILESDIR}"/${P}-python27.patch
)

src_install() {
	if use examples; then
		exeinto /usr/share/${PN}/examples
		doexe 00_sleepproxyclient checkSleep.sh
	fi

	if use pm-utils; then
		exeinto /etc/pm/sleep.d
		doexe 00_sleepproxyclient
	fi

	exeinto /usr/share/${PN}/scripts
	doexe sleepproxyclient.{py,sh}

	insinto /etc
	newins debian/sleepproxyclient.default sleepproxyclient

	einstalldocs
}
