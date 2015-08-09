# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit linux-mod versionator

MY_PN=${PN/-ng/}
MY_PV=$(get_version_component_range 1-3)
MY_REV=$(get_version_component_range 4)
MY_DATE=$(get_version_component_range 5)
MY_P=${MY_PN}-${MY_PV}-r${MY_REV}-${MY_DATE}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Next Generation driver for Atheros based IEEE 802.11a/b/g wireless LAN cards"
HOMEPAGE="http://www.madwifi-project.org/"
SRC_URI="http://snapshots.madwifi-project.org/${MY_PN}-${MY_PV}/${MY_P}.tar.gz"

LICENSE="atheros-hal
	|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="injection"

RDEPEND="!net-wireless/madwifi-old
		net-wireless/wireless-tools
		~net-wireless/madwifi-ng-tools-${PV}"

pkg_setup() {
	CONFIG_CHECK="CRYPTO WIRELESS_EXT SYSCTL"
	kernel_is lt 2 6 29 && CONFIG_CHECK="${CONFIG_CHECK} KMOD"
	ERROR_CRYPTO="${P} requires Cryptographic API support (CONFIG_CRYPTO)."
	ERROR_WIRELESS_EXT="${P} requires CONFIG_WIRELESS_EXT selected by Wireless LAN drivers (non-hamradio) & Wireless Extensions"
	kernel_is gt 2 6 33 && \
	ERROR_WIRELESS_EXT="${P} requires CONFIG_WIRELESS_EXT selected by some Wireless LAN drivers (e.g CONFIG_IPW2100)"
	ERROR_SYSCTL="${P} requires Sysctl support (CONFIG_SYSCTL)."
	ERROR_KMOD="${F} requires CONFIG_KMOD to be set to y or m"
	BUILD_TARGETS="all"
	MODULESD_ATH_PCI_DOCS="README"
	linux-mod_pkg_setup

	MODULE_NAMES='ath_hal(net:"${S}"/ath_hal)
				wlan(net:"${S}"/net80211)
				wlan_acl(net:"${S}"/net80211)
				wlan_ccmp(net:"${S}"/net80211)
				wlan_tkip(net:"${S}"/net80211)
				wlan_wep(net:"${S}"/net80211)
				wlan_xauth(net:"${S}"/net80211)
				wlan_scan_sta(net:"${S}"/net80211)
				wlan_scan_ap(net:"${S}"/net80211)
				ath_rate_amrr(net:"${S}"/ath_rate/amrr)
				ath_rate_onoe(net:"${S}"/ath_rate/onoe)
				ath_rate_sample(net:"${S}"/ath_rate/sample)
				ath_rate_minstrel(net:"${S}"/ath_rate/minstrel)
				ath_pci(net:"${S}"/ath)'

	BUILD_PARAMS="KERNELPATH=${KV_OUT_DIR}"
}

src_prepare() {
	use injection && epatch "${FILESDIR}"/${PN}-injection-r3925.patch
	for dir in ath ath_hal net80211 ath_rate ath_rate/amrr ath_rate/minstrel ath_rate/onoe ath_rate/sample; do
		convert_to_m "${S}/${dir}/Makefile"
	done
	sed -e 's:-Werror ::' -i Makefile.inc || die "sed -Werror failed"
	make svnversion.h || die
}

src_install() {
	linux-mod_src_install
	dodoc README THANKS SNAPSHOT || die
}

pkg_postinst() {
	local moddir="${ROOT}/lib/modules/${KV_FULL}/net/"

	linux-mod_pkg_postinst

	einfo
	einfo "Interfaces (athX) are now automatically created upon loading the ath_pci"
	einfo "module."
	einfo
	einfo "The type of the created interface can be controlled through the 'autocreate'"
	einfo "module parameter."
	einfo
	einfo "As of net-wireless/madwifi-ng-0.9.3 rate control module selection is done at"
	einfo "module load time via the 'ratectl' module parameter."

	elog "Please note: This release is based off of 0.9.3.3 and NOT trunk."
	elog "# No AR5007 support in this release;"
	elog "experimental support is available for i386 (32bit) in #1679"
	elog "# No AR5008 support in this release; support is available in trunk "
	elog "No, we will not apply the patch from 1679, if you must, please do so
	in an overlay on your system. That is upstreams ticket 1679, not Gentoo's."
}
