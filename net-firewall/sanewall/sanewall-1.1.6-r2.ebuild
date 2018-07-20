# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info

DESCRIPTION="iptables firewall generator (fork of firehol)"
HOMEPAGE="https://www.sanewall.org"
SRC_URI="https://download.sanewall.org/releases/${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	net-firewall/iptables[ipv6]
	sys-apps/iproute2[-minimal]
	sys-apps/net-tools
	virtual/modutils
	|| (
		net-misc/wget
		net-misc/curl
	)
"
DEPEND=""

pkg_setup() {
	local KCONFIG_OPTS="~NF_CONNTRACK_IPV4 ~NF_CONNTRACK_MARK ~NF_NAT ~NF_NAT_FTP ~NF_NAT_IRC \
		~IP_NF_IPTABLES ~IP_NF_FILTER ~IP_NF_TARGET_REJECT ~IP_NF_TARGET_LOG ~IP_NF_TARGET_ULOG \
		~IP_NF_TARGET_MASQUERADE ~IP_NF_TARGET_REDIRECT ~IP_NF_MANGLE \
		~NETFILTER_XT_MATCH_LIMIT ~NETFILTER_XT_MATCH_STATE ~NETFILTER_XT_MATCH_OWNER"

	get_version
	if [[ ${KV_PATCH} -ge 25 ]] ; then
		CONFIG_CHECK="~NF_CONNTRACK ${KCONFIG_OPTS}"
	else
		CONFIG_CHECK="~NF_CONNTRACK_ENABLED ${KCONFIG_OPTS}"
	fi
	linux-info_pkg_setup
}

src_configure() {
	econf --docdir="/usr/share/doc/${PF}"
}

src_install() {
	default
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
}

pkg_postinst() {
	# install default configuration if it doesn't exist
	if [[ ! -e "${ROOT}"/etc/${PN}/${PN}.conf ]] ; then
		einfo "Installing a sample configuration to ${ROOT}/etc/${PN}/${PN}.conf"
		cp "${ROOT}"/etc/${PN}/${PN}.conf.example "${ROOT}"/etc/${PN}/${PN}.conf || die
	fi
}
