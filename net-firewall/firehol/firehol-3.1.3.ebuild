# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils linux-info

DESCRIPTION="iptables firewall generator"
HOMEPAGE="https://github.com/firehol/firehol"
SRC_URI="https://github.com/firehol/firehol/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc ipv6"
KEYWORDS="amd64 arm ppc"

RDEPEND="net-firewall/iptables
	sys-apps/iproute2[-minimal,ipv6?]
	net-misc/iputils[ipv6?]
	net-misc/iprange
	net-analyzer/traceroute
	virtual/modutils
	app-arch/gzip"
DEPEND="${RDEPEND}"

pkg_setup() {
	local KCONFIG_OPTS=" \
		~IP_NF_FILTER \
		~IP_NF_IPTABLES \
		~IP_NF_MANGLE \
		~IP_NF_TARGET_MASQUERADE
		~IP_NF_TARGET_REDIRECT \
		~IP_NF_TARGET_REJECT \
		~NETFILTER_XT_MATCH_LIMIT \
		~NETFILTER_XT_MATCH_OWNER \
		~NETFILTER_XT_MATCH_STATE \
		~NF_CONNTRACK \
		~NF_CONNTRACK_IPV4 \
		~NF_CONNTRACK_MARK \
		~NF_NAT \
		~NF_NAT_FTP \
		~NF_NAT_IRC \
	"
	linux-info_pkg_setup
}

src_configure() {
	econf \
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
