# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info

DESCRIPTION="iptables firewall generator"
HOMEPAGE="https://firehol.org/ https://github.com/firehol/firehol"
SRC_URI="https://github.com/firehol/firehol/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc ipv6 ipset"
KEYWORDS="amd64 arm ~ppc ~x86"

RDEPEND="net-firewall/iptables
	sys-apps/iproute2[-minimal,ipv6?]
	net-misc/iputils[ipv6?]
	net-misc/iprange
	net-analyzer/traceroute
	virtual/modutils
	app-arch/gzip
	ipset? (
		net-firewall/ipset
	)"
DEPEND="${RDEPEND}"

pkg_setup() {
	local CONFIG_CHECK=" \
		~IP_NF_FILTER \
		~IP_NF_IPTABLES \
		~IP_NF_MANGLE \
		~IP_NF_TARGET_MASQUERADE
		~IP_NF_TARGET_REDIRECT \
		~IP_NF_TARGET_REJECT \
		~NETFILTER_XT_CONNMARK \
		~NETFILTER_XT_MATCH_HELPER \
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
		$(use_enable ipset update-ipsets) \
		$(use_enable doc) \
		$(use_enable ipv6)
}

src_install() {
	default

	newconfd "${FILESDIR}"/firehol.confd firehol
	newinitd "${FILESDIR}"/firehol.initd firehol
	newconfd "${FILESDIR}"/fireqos.confd fireqos
	newinitd "${FILESDIR}"/fireqos.initd fireqos
}
