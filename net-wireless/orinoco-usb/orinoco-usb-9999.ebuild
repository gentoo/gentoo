# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit linux-mod subversion

ESVN_REPO_URI="http://orinoco.svn.sourceforge.net/svnroot/orinoco/branches/usb"

DESCRIPTION="ORiNOCO IEEE 802.11 wireless LAN driver"
HOMEPAGE="http://www.nongnu.org/orinoco/"
SRC_URI=""

LICENSE="GPL-2 MPL-1.1"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="!net-wireless/orinoco-sn
	net-wireless/wireless-tools
	net-wireless/orinoco-fwutils"

BUILD_TARGETS="all"

CONFIG_CHECK="FW_LOADER WIRELESS_EXT USB"
ERROR_FW_LOADER="${P} requires support for loading firmware (CONFIG_FWLOADER)."
ERROR_WIRELESS_EXT="${P} requires support for Wireless LAN drivers (non-hamradio) & Wireless Extensions (CONFIG_WIRELESS_EXT)."
ERROR_USB="${P} requires USB support (CONFIG_USB)."

pkg_setup() {
	linux-mod_pkg_setup

	if kernel_is lt 2 6 21; then
		eerror "${P} requires kernel 2.6.21 or above."
		die "Kernel version too old."
	fi

	MOD_PATH="/net/wireless"
	MODULE_NAMES="orinoco(${MOD_PATH}:) orinoco_usb(${MOD_PATH}:)"
	BUILD_PARAMS="KERNEL_PATH=${KV_OUT_DIR}"
}

# Don't have modified install in order to provide docs, since docs are too old
