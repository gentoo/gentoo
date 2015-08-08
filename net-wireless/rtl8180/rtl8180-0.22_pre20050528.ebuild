# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit linux-mod eutils

DESCRIPTION="Driver for the rtl8180 wireless chipset"
HOMEPAGE="http://rtl8180-sa2400.sourceforge.net"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"

KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND="net-wireless/wireless-tools"

MODULE_NAMES="ieee80211_crypt-r8180(net:) ieee80211_crypt_wep-r8180(net:)
	ieee80211-r8180(net:) r8180(net:)"
CONFIG_CHECK="WIRELESS_EXT CRYPTO CRYPTO_ARC4 CRC32"
BUILD_TARGETS="all"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KSRC=${KV_OUT_DIR}"
}

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e 's:MODULE_PARM(\([^,]*\),"i");:module_param(\1, int, 0);:' \
		-e 's:MODULE_PARM(\([^,]*\),"s");:module_param(\1, charp, 0);:' r8180_core.c
	sed -i -e 's:MODVERDIR=$(PWD) ::' {,ieee80211/}Makefile

	# 2.6.19 patch
	epatch ${FILESDIR}/${PN}-2.6.19.patch

	# 2.6.20 patch
	epatch ${FILESDIR}/${PN}-2.6.20.patch
}

src_install() {
	linux-mod_src_install

	dodoc AUTHORS CHANGES INSTALL README README.adhoc
}
