# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="ADSL4Linux, a PPTP start/stop/etc. program especially for Dutch users"
HOMEPAGE="http://www.adsl4linux.nl/"
SRC_URI="http://home.planet.nl/~mcdon001/${P}.tar.gz
	http://www.adsl4linux.nl/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND="
	net-dialup/ppp
	net-dialup/pptpclient"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	tc-export CC
	default

	sed -i -e 's:* at first:/\0:' adslstatus.c || die
	sed -i -e 's/runscript/openrc-run/g' init.d.adsl || die
}

src_install() {
	dosbin adsl
	dodoc Changelog modemREADME README
	newinitd init.d.adsl adsl
	dosbin "${FILESDIR}/${PN}-config"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Do _NOT_ forget to run the following if this is your _FIRST_ install:"
		elog "   kpnadsl4linux-config"
		elog "   etc-update"
		elog "To start ${P} at boot type:"
		elog "   rc-update add adsl default"
	fi
}
