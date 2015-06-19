# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/madwifi-ng-tools/madwifi-ng-tools-0.9.4.4180.20120502.ebuild,v 1.4 2012/09/29 04:07:44 blueness Exp $

EAPI="2"

inherit versionator toolchain-funcs

MY_PN=${PN/-ng-tools/}
MY_PV=$(get_version_component_range 1-3)
MY_REV=$(get_version_component_range 4)
MY_DATE=$(get_version_component_range 5)
MY_P=${MY_PN}-${MY_PV}-r${MY_REV}-${MY_DATE}
S=${WORKDIR}/${MY_P}/tools

DESCRIPTION="Next Generation tools for configuration of Atheros based IEEE 802.11a/b/g wireless LAN cards"
HOMEPAGE="http://www.madwifi-project.org/"
SRC_URI="http://snapshots.madwifi-project.org/${MY_PN}-${MY_PV}/${MY_P}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND="!net-wireless/madwifi-old-tools"

src_prepare() {
	# format string fix from solar
	#sed -i \
#		-e 's:err(1, ifr.ifr_name);:err(1, "%s", ifr.ifr_name);:g' \
#		${S}/tools/athstats.c || die

	sed -i \
		-e "s:CC =.*:CC = $(tc-getCC):" \
		-e "s:CFLAGS=:CFLAGS+=:" \
		-e "s:LDFLAGS=:LDFLAGS+=:" \
		"${S}"/Makefile || die
}

src_install() {
	emake DESTDIR="${D}" BINDIR=/usr/bin MANDIR=/usr/share/man STRIP=echo \
		install || die "emake install failed"

	dodir /sbin
	mv "${D}"/usr/bin/wlanconfig "${D}"/sbin

	# install headers for use by
	# net-wireless/wpa_supplicant and net-wireless/hostapd
	cd "${S}"/..
	insinto /usr/include/madwifi/include/
	doins include/*.h
	insinto /usr/include/madwifi/net80211
	doins net80211/*.h
}

pkg_postinst() {
	if [ -e "${ROOT}"/etc/udev/rules.d/65-madwifi.rules ]; then
		ewarn
		ewarn "The udev rules for creating interfaces (athX) are no longer needed."
		ewarn
		ewarn "You should manually remove the /etc/udev/rules.d/65-madwifi.rules file"
		ewarn "and either run 'udevstart' or reboot for the changes to take effect."
		ewarn
	fi
	einfo
	einfo "If you use net-wireless/wpa_supplicant or net-wireless/hostapd with madwifi"
	einfo "you should remerge them now."
	einfo
}
