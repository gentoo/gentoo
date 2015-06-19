# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/broadcom-sta/broadcom-sta-6.30.223.30-r2.ebuild,v 1.2 2014/08/10 20:34:33 slyfox Exp $

EAPI="5"
inherit eutils linux-info linux-mod unpacker

DESCRIPTION="Broadcom's IEEE 802.11a/b/g/n hybrid Linux device driver"
HOMEPAGE="https://launchpad.net/ubuntu/+source/bcmwl http://www.broadcom.com/support/802.11/linux_sta.php"
BASE_URI="https://launchpad.net/~albertomilone/+archive/broadcom/+files"
BASE_NAME="bcmwl-kernel-source_${PV}%2Bbdcom-0ubuntu1%7Eppa1_"
SRC_URI="amd64? ( ${BASE_URI}/${BASE_NAME}amd64.deb )
		x86? ( ${BASE_URI}/${BASE_NAME}i386.deb )"

LICENSE="Broadcom"
KEYWORDS="-* ~amd64 ~x86"

RESTRICT="mirror"

DEPEND="virtual/linux-sources"
RDEPEND=""

#S="${WORKDIR}"
S="${WORKDIR}/usr/src/bcmwl-${PV}+bdcom"

MODULE_NAMES="wl(net/wireless)"
MODULESD_WL_ALIASES=("wlan0 wl")

pkg_setup() {
	# bug #300570
	# NOTE<lxnay>: module builds correctly anyway with b43 and SSB enabled
	# make checks non-fatal. The correct fix is blackisting ssb and, perhaps
	# b43 via udev rules. Moreover, previous fix broke binpkgs support.
	CONFIG_CHECK="~!B43 ~!SSB"
	CONFIG_CHECK2="LIB80211 ~!MAC80211 ~LIB80211_CRYPT_TKIP"
	ERROR_B43="B43: If you insist on building this, you must blacklist it!"
	ERROR_SSB="SSB: If you insist on building this, you must blacklist it!"
	ERROR_LIB80211="LIB80211: Please enable it. If you can't find it: enabling the driver for \"Intel PRO/Wireless 2100\" or \"Intel PRO/Wireless 2200BG\" (IPW2100 or IPW2200) should suffice."
	ERROR_MAC80211="MAC80211: If you insist on building this, you must blacklist it!"
	ERROR_PREEMPT_RCU="PREEMPT_RCU: Please do not set the Preemption Model to \"Preemptible Kernel\"; choose something else."
	ERROR_LIB80211_CRYPT_TKIP="LIB80211_CRYPT_TKIP: You will need this for WPA."
	if kernel_is ge 3 8 8; then
		CONFIG_CHECK="${CONFIG_CHECK} ${CONFIG_CHECK2} CFG80211 ~!PREEMPT_RCU"
	elif kernel_is ge 2 6 32; then
		CONFIG_CHECK="${CONFIG_CHECK} ${CONFIG_CHECK2} CFG80211"
	elif kernel_is ge 2 6 31; then
		CONFIG_CHECK="${CONFIG_CHECK} ${CONFIG_CHECK2} WIRELESS_EXT ~!MAC80211"
	elif kernel_is ge 2 6 29; then
		CONFIG_CHECK="${CONFIG_CHECK} ${CONFIG_CHECK2} WIRELESS_EXT COMPAT_NET_DEV_OPS"
	else
		CONFIG_CHECK="${CONFIG_CHECK} IEEE80211 IEEE80211_CRYPT_TKIP"
	fi

	linux-mod_pkg_setup

	BUILD_PARAMS="-C ${KV_DIR} M=${S}"
	BUILD_TARGETS="wl.ko"
}

src_unpack() {
	local arch_suffix
	if use amd64; then
		arch_suffix="amd64"
	else
		arch_suffix="i386"
	fi
	unpack_deb "${BASE_NAME}${arch_suffix}.deb"
}

src_prepare() {
#	Filter the outdated patches here
	EPATCH_FORCE="yes" EPATCH_EXCLUDE="0002* 0004* 0005*" EPATCH_SOURCE="${S}/patches" EPATCH_SUFFIX=patch epatch
#	Makefile.patch: keep `emake install` working
#	linux-3.9.0.patch: add support for kernel 3.9.0
#	linux-3.10.0.patch: add support for kernel 3.10, bug #477372
	epatch "${FILESDIR}/${P}-makefile.patch" \
		"${FILESDIR}/${P}-linux-3.9.0.patch" \
		"${FILESDIR}/${P}-linux-3.10.0.patch"
	mv "${S}/lib/wlc_hybrid.o_shipped_"* "${S}/lib/wlc_hybrid.o_shipped" \
		|| die "Where is the blob?"

	epatch_user
}
