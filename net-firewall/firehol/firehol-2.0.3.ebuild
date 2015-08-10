# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils linux-info

DESCRIPTION="iptables firewall generator"
HOMEPAGE="http://firehol.sourceforge.net/"
SRC_URI="http://firehol.org/download/releases/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="net-firewall/iptables
	sys-apps/iproute2[-minimal]
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
	# removing IP6TABLES_CMD has no effect and enable build
	# without ipv6 available
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--with-autosave="${EPREFIX}/var/lib/iptables/rules-save" \
		--with-autosave6="${EPREFIX}/var/lib/ip6tables/rules-save" \
		$(use_enable doc) \
		IP6TABLES_CMD=/bin/false \
		IP6TABLES_SAVE_CMD=/bin/false
}

src_install() {
	default

	newconfd "${FILESDIR}"/firehol.conf.d firehol
	newinitd "${FILESDIR}"/firehol.initrd.1 firehol
	newconfd "${FILESDIR}"/fireqos.conf.d fireqos
	newinitd "${FILESDIR}"/fireqos.initrd fireqos
}
