# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info linux-mod

DESCRIPTION="Broadcom's IEEE 802.11a/b/g/n hybrid Linux device driver"
HOMEPAGE="https://www.broadcom.com/support/802.11"
SRC_BASE="https://docs.broadcom.com/docs-and-downloads/docs/linux_sta/hybrid-v35"
SRC_URI="x86? ( ${SRC_BASE}-nodebug-pcoem-${PV//\./_}.tar.gz )
	amd64? ( ${SRC_BASE}_64-nodebug-pcoem-${PV//\./_}.tar.gz )
	https://docs.broadcom.com/docs-and-downloads/docs/linux_sta/README_${PV}.txt -> README-${P}.txt"
S="${WORKDIR}"

LICENSE="Broadcom"
KEYWORDS="-* ~amd64 ~x86"

RESTRICT="mirror"

DEPEND="virtual/linux-sources"

PATCHES=(
	"${FILESDIR}/${PN}-6.30.223.141-makefile.patch"
	"${FILESDIR}/${PN}-6.30.223.141-eth-to-wlan.patch"
	"${FILESDIR}/${PN}-6.30.223.141-gcc.patch"
	"${FILESDIR}/${PN}-6.30.223.248-r3-Wno-date-time.patch"
	"${FILESDIR}/${PN}-6.30.223.271-r1-linux-3.18.patch"
	"${FILESDIR}/${PN}-6.30.223.271-r2-linux-4.3-v2.patch"
	"${FILESDIR}/${PN}-6.30.223.271-r4-linux-4.7.patch"
	"${FILESDIR}/${PN}-6.30.223.271-r4-linux-4.8.patch"
	"${FILESDIR}/${PN}-6.30.223.271-r4-linux-4.11.patch"
	"${FILESDIR}/${PN}-6.30.223.271-r4-linux-4.12.patch"
	"${FILESDIR}/${PN}-6.30.223.271-r4-linux-4.15.patch"
	"${FILESDIR}/${PN}-6.30.223.271-r5-linux-5.1.patch"
	"${FILESDIR}/${PN}-6.30.223.271-r5-linux-5.6.patch"
)

MODULE_NAMES="wl(net/wireless)"
MODULESD_WL_ALIASES=("wlan0 wl")

pkg_pretend() {
	ewarn
	ewarn "If you are stuck using this unmaintained driver (likely in a MacBook),"
	ewarn "you may be interested to know that a newer compatible wireless card"
	ewarn "is supported by the in-tree brcmfmac driver. It has a model number "
	ewarn "BCM943602CS and is for sale on the second hand market for less than "
	ewarn "20 USD."
	ewarn
	ewarn "See https://wikidevi.com/wiki/Broadcom_Wireless_Adapters and"
	ewarn "    https://wikidevi.com/wiki/Broadcom_BCM943602CS"
	ewarn "for more information."
	ewarn
}

pkg_setup() {
	# bug #300570
	# NOTE<lxnay>: module builds correctly anyway with b43 and SSB enabled
	# make checks non-fatal. The correct fix is blackisting ssb and, perhaps
	# b43 via udev rules. Moreover, previous fix broke binpkgs support.
	CONFIG_CHECK="~!B43 ~!BCMA ~!SSB ~!X86_INTEL_LPSS"
	CONFIG_CHECK2="LIB80211 ~!MAC80211 ~LIB80211_CRYPT_TKIP"
	ERROR_B43="B43: If you insist on building this, you must blacklist it!"
	ERROR_BCMA="BCMA: If you insist on building this, you must blacklist it!"
	ERROR_SSB="SSB: If you insist on building this, you must blacklist it!"
	ERROR_LIB80211="LIB80211: Please enable it. If you can't find it: enabling the driver for \"Intel PRO/Wireless 2100\" or \"Intel PRO/Wireless 2200BG\" (IPW2100 or IPW2200) should suffice."
	ERROR_MAC80211="MAC80211: If you insist on building this, you must blacklist it!"
	ERROR_PREEMPT_RCU="PREEMPT_RCU: Please do not set the Preemption Model to \"Preemptible Kernel\"; choose something else."
	ERROR_LIB80211_CRYPT_TKIP="LIB80211_CRYPT_TKIP: You will need this for WPA."
	ERROR_X86_INTEL_LPSS="X86_INTEL_LPSS: Please disable it. The module does not work with it enabled."
	if kernel_is ge 3 8 8; then
		CONFIG_CHECK="${CONFIG_CHECK} ${CONFIG_CHECK2} CFG80211 ~!PREEMPT_RCU ~!PREEMPT"
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

src_install() {
	linux-mod_src_install

	dodoc "${DISTDIR}/README-${P}.txt"
}
