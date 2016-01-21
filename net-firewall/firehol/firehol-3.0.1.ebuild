# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils linux-info

DESCRIPTION="iptables firewall generator"
HOMEPAGE="http://firehol.sourceforge.net/"
SRC_URI="https://firehol.org/download/firehol/releases/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc ipv6"
KEYWORDS="~amd64"

RDEPEND="net-firewall/iptables
	sys-apps/iproute2[-minimal]
	net-misc/iprange
	virtual/modutils
	app-arch/gzip"
DEPEND="${RDEPEND}"

pkg_setup() {
	local KCONFIG_OPTS="~NF_CONNTRACK_IPV4 ~NF_CONNTRACK_MARK ~NF_NAT ~NF_NAT_FTP ~NF_NAT_IRC \
		~IP_NF_IPTABLES ~IP_NF_FILTER ~IP_NF_TARGET_REJECT ~IP_NF_TARGET_LOG ~IP_NF_TARGET_ULOG \
		~IP_NF_TARGET_MASQUERADE ~IP_NF_TARGET_REDIRECT ~IP_NF_MANGLE \
		~NETFILTER_XT_MATCH_LIMIT ~NETFILTER_XT_MATCH_STATE ~NETFILTER_XT_MATCH_OWNER"

	get_version
	if [ ${KV_PATCH} -ge 25 ]; then
		CONFIG_CHECK="~NF_CONNTRACK ${KCONFIG_OPTS}"
	else
		CONFIG_CHECK="~NF_CONNTRACK_ENABLED ${KCONFIG_OPTS}"
	fi
	linux-info_pkg_setup
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--disable-vnetbuild \
		--disable-update-ipsets \
		$(use_enable doc) \
		$(use_enable ipv6)
}

src_install() {
	default

	newconfd "${FILESDIR}"/firehol.conf.d firehol
	newinitd "${FILESDIR}"/firehol.initrd firehol
	newconfd "${FILESDIR}"/fireqos.conf.d fireqos
	newinitd "${FILESDIR}"/fireqos.initrd fireqos
}
