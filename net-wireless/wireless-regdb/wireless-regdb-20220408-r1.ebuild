# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info

MY_P="wireless-regdb-${PV:0:4}.${PV:4:2}.${PV:6:2}"
DESCRIPTION="Regulatory database for Linux"
HOMEPAGE="https://wireless.wiki.kernel.org/en/developers/regulatory/wireless-regdb"
SRC_URI="https://mirrors.edge.kernel.org/pub/software/network/${PN}/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="crda"

RDEPEND="crda? ( net-wireless/crda )"

REQUIRED_USE="kernel_linux"

pkg_pretend() {
	if kernel_is -ge 4 15; then
	if linux_config_exists && linux_chkconfig_builtin CFG80211 &&
		[[ $(linux_chkconfig_string EXTRA_FIRMWARE) != *regulatory.db* ]]
	then
		ewarn "REGULATORY DOMAIN PROBLEM:"
		ewarn "  With CONFIG_CFG80211=y (built-in), the driver won't be able to load regulatory.db from"
		ewarn "  /lib/firmware, resulting in broken regulatory domain support. Please set CONFIG_CFG80211=m"
		ewarn "  or add regulatory.db and regulatory.db.p7s to CONFIG_EXTRA_FIRMWARE."
	fi

	has_version net-wireless/crda && \
		ewarn "Starting from kernel version 4.15 net-wireless/crda is no longer needed."

	CONFIG_CHECK="EXPERT !CFG80211_CRDA_SUPPORT"
	WARNING_CFG80211_CRDA_SUPPORT="You can safely disable CFG80211_CRDA_SUPPORT"
	else
	CONFIG_CHECK="~CFG80211_CRDA_SUPPORT"
	WARNING_CFG80211_CRDA_SUPPORT="REGULATORY DOMAIN PROBLEM: \
please enable CFG80211_CRDA_SUPPORT for proper regulatory domain support"
	fi

	check_extra_config
}

src_compile() {
	true
}

src_install() {
	if kernel_is -lt 4 15; then
	# This file is not ABI-specific, and crda itself always hardcodes
	# this path.  So install into a common location for all ABIs to use.
	insinto /usr/lib/crda
	doins regulatory.bin

	insinto /etc/wireless-regdb/pubkeys
	doins sforshee.key.pub.pem
	else
	insinto /lib/firmware
	doins regulatory.db regulatory.db.p7s
	fi
	doman -i18n= regulatory.bin.5 regulatory.db.5
	dodoc README db.txt
}
