# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info

MY_P="wireless-regdb-${PV:0:4}.${PV:4:2}.${PV:6:2}"
DESCRIPTION="Wireless Regulatory database for Linux"
HOMEPAGE="https://wireless.wiki.kernel.org/en/developers/regulatory/wireless-regdb"
SRC_URI="https://mirrors.edge.kernel.org/pub/software/network/${PN}/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
REQUIRED_USE="kernel_linux"

pkg_pretend() {
	if kernel_is -ge 4 15; then
		if linux_config_exists; then
			if linux_chkconfig_builtin CFG80211 &&
				[[ $(linux_chkconfig_string EXTRA_FIRMWARE) != *regulatory.db* ]]; then
				ewarn "REGULATORY DOMAIN PROBLEM:"
				ewarn "  With CONFIG_CFG80211=y (built-in), the driver(s) won't be able to load regulatory.db from"
				ewarn "  /lib/firmware, resulting in broken regulatory domain support. Please set CONFIG_CFG80211=m"
				ewarn "  or add regulatory.db and regulatory.db.p7s to CONFIG_EXTRA_FIRMWARE."
			fi
			if ! linux_chkconfig_present CFG80211; then
				ewarn "REGULATORY DOMAIN PROBLEM:"
				ewarn "  With CONFIG_CFG80211 unset, the driver(s) won't be able to load the regulatory.db from"
				ewarn "  /lib/firmware, resulting in broken regulatory domain support. Please set CONFIG_CFG80211=m."
			fi
			if linux_chkconfig_present EXPERT && linux_chkconfig_present CFG80211_CRDA_SUPPORT; then
				ewarn "You can safely disable CFG80211_CRDA_SUPPORT"
			fi
		fi
	else
		CONFIG_CHECK="~CFG80211_CRDA_SUPPORT"
		WARNING_CFG80211_CRDA_SUPPORT="REGULATORY DOMAIN PROBLEM: \
please enable CFG80211_CRDA_SUPPORT for proper regulatory domain support"
	fi

	check_extra_config
}

src_compile() {
	einfo "Recompiling regulatory database(s) from db.txt would break signature verification."
	einfo "Installing unmodified binary version."
}

src_install() {
	# install the files the kernel needs unconditionally,
	# they are small and kernels get upgraded
	insinto /lib/firmware
	doins regulatory.db regulatory.db.p7s

	echo '.so man5/regulatory.bin.5' > regulatory.db.5 || die
	# without -i18n= workaround regulatory.db.5 is installed as db/man5/regulatory.5
	doman -i18n= regulatory.db.5 regulatory.bin.5
	dodoc README db.txt
}
