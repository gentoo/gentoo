# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/rfswitch/rfswitch-1.3.ebuild,v 1.1 2012/11/28 21:23:57 ssuominen Exp $

inherit linux-mod

DESCRIPTION="Drivers for software based wireless radio switches"
HOMEPAGE="http://rfswitch.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BUILD_TARGETS="modules"

MODULE_NAMES="av5100(net/wireless:)
			  pbe5(net/wireless:)"
MODULESD_AV5100_DOCS="README"

# Use the in-kernel ipw2100 modules
CONFIG_CHECK="~IPW2100"
ERROR_IPW2100="${P} requires support for ipw2100 (CONFIG_IPW2100)."

pkg_setup() {
	linux-mod_pkg_setup

	if kernel_is 2 4; then
		die "${P} does not support building against kernel 2.4.x"
	fi

	BUILD_PARAMS="KSRC=${KV_DIR}"
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	convert_to_m Makefile

	sed -i \
		-e '/depmod/d' \
		-e '/include.*Rules.*make/d' \
		Makefile || die

	sed -i -e 's:&proc_root:NULL:' {av5100,pbe5}.c || die #270269
}

src_install() {
	linux-mod_src_install

	dodoc ISSUES README
}
