# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info bash-completion-r1 systemd toolchain-funcs

DESCRIPTION="Required tools for WireGuard, such as wg(8) and wg-quick(8)"
HOMEPAGE="https://www.wireguard.com/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.zx2c4.com/wireguard-tools"
else
	SRC_URI="https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-${PV}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+wg-quick"

BDEPEND="virtual/pkgconfig"
DEPEND=""
RDEPEND="${DEPEND}
	wg-quick? (
		|| ( net-firewall/nftables net-firewall/iptables )
		virtual/resolvconf
	)
"

wg_quick_optional_config_nob() {
	CONFIG_CHECK="$CONFIG_CHECK ~$1"
	declare -g ERROR_$1="CONFIG_$1: This option is required for automatic routing of default routes inside of wg-quick(8), though it is not required for general WireGuard usage."
}

pkg_setup() {
	if use wg-quick; then
		wg_quick_optional_config_nob IP_ADVANCED_ROUTER
		wg_quick_optional_config_nob IP_MULTIPLE_TABLES
		wg_quick_optional_config_nob IPV6_MULTIPLE_TABLES
		if has_version net-firewall/nftables; then
			wg_quick_optional_config_nob NF_TABLES
			wg_quick_optional_config_nob NF_TABLES_IPV4
			wg_quick_optional_config_nob NF_TABLES_IPV6
			wg_quick_optional_config_nob NFT_CT
			wg_quick_optional_config_nob NFT_FIB
			wg_quick_optional_config_nob NFT_FIB_IPV4
			wg_quick_optional_config_nob NFT_FIB_IPV6
			wg_quick_optional_config_nob NF_CONNTRACK_MARK
		elif has_version net-firewall/iptables; then
			wg_quick_optional_config_nob NETFILTER_XTABLES
			wg_quick_optional_config_nob NETFILTER_XT_MARK
			wg_quick_optional_config_nob NETFILTER_XT_CONNMARK
			wg_quick_optional_config_nob NETFILTER_XT_MATCH_COMMENT
			wg_quick_optional_config_nob NETFILTER_XT_MATCH_ADDRTYPE
			wg_quick_optional_config_nob IP6_NF_RAW
			wg_quick_optional_config_nob IP_NF_RAW
			wg_quick_optional_config_nob IP6_NF_FILTER
			wg_quick_optional_config_nob IP_NF_FILTER
		fi
	fi
	get_version
	if [[ -f $KERNEL_DIR/include/uapi/linux/wireguard.h ]]; then
		CONFIG_CHECK="~WIREGUARD $CONFIG_CHECK"
		declare -g ERROR_WIREGUARD="CONFIG_WIREGUARD: This option is required for using WireGuard."
	elif kernel_is -ge 3 10 0 && kernel_is -lt 5 6 0 && ! has_version net-vpn/wireguard-modules; then
		ewarn
		ewarn "Your kernel does not appear to have upstream support for WireGuard"
		ewarn "via CONFIG_WIREGUARD. However, the net-vpn/wireguard-modules ebuild"
		ewarn "contains a compatibility module that should work for your kernel."
		ewarn "It is highly recommended to install it:"
		ewarn
		ewarn "    emerge -av net-vpn/wireguard-modules"
		ewarn
	fi
	linux-info_pkg_setup
}

src_compile() {
	emake RUNSTATEDIR="${EPREFIX}/run" -C src CC="$(tc-getCC)" LD="$(tc-getLD)"
}

src_install() {
	dodoc README.md
	dodoc -r contrib
	emake \
		WITH_BASHCOMPLETION=yes \
		WITH_SYSTEMDUNITS=yes \
		WITH_WGQUICK=$(usex wg-quick) \
		DESTDIR="${D}" \
		BASHCOMPDIR="$(get_bashcompdir)" \
		SYSTEMDUNITDIR="$(systemd_get_systemunitdir)" \
		PREFIX="${EPREFIX}/usr" \
		-C src install
	use wg-quick && newinitd "${FILESDIR}/wg-quick.init" wg-quick
}

pkg_postinst() {
	einfo
	einfo "After installing WireGuard, if you'd like to try sending some packets through"
	einfo "WireGuard, you may use, for testing purposes only, the insecure client.sh"
	einfo "test example script:"
	einfo
	einfo "  \$ bzcat ${ROOT}/usr/share/doc/${PF}/contrib/ncat-client-server/client.sh.bz2 | sudo bash -"
	einfo
	einfo "This will automatically setup interface wg0, through a very insecure transport"
	einfo "that is only suitable for demonstration purposes. You can then try loading the"
	einfo "hidden website or sending pings:"
	einfo
	einfo "  \$ chromium http://192.168.4.1"
	einfo "  \$ ping 192.168.4.1"
	einfo
	einfo "More info on getting started can be found at: https://www.wireguard.com/quickstart/"
	einfo
}
