# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools bash-completion-r1 linux-info systemd

DESCRIPTION="IPset tool for iptables, successor to ippool"
HOMEPAGE="https://ipset.netfilter.org/ https://git.netfilter.org/ipset/"
SRC_URI="https://ipset.netfilter.org/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	>=net-firewall/iptables-1.8.9
	net-libs/libmnl:=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( ChangeLog INSTALL README UPGRADE )

# configurable from outside, e.g. /etc/portage/make.conf
IP_NF_SET_MAX=${IP_NF_SET_MAX:-256}

pkg_setup() {
	get_version
	CONFIG_CHECK="NETFILTER"
	ERROR_NETFILTER="ipset requires NETFILTER support in your kernel."
	CONFIG_CHECK+=" NETFILTER_NETLINK"
	ERROR_NETFILTER_NETLINK="ipset requires NETFILTER_NETLINK support in your kernel."
	# It does still build without NET_NS, but it may be needed in future.
	#CONFIG_CHECK="${CONFIG_CHECK} NET_NS"
	#ERROR_NET_NS="ipset requires NET_NS (network namespace) support in your kernel."
	CONFIG_CHECK+=" !PAX_CONSTIFY_PLUGIN"
	ERROR_PAX_CONSTIFY_PLUGIN="ipset contains constified variables (#614896)"
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	export bashcompdir="$(get_bashcompdir)"

	econf \
		--enable-bashcompl \
		--with-kmod=no \
		--with-maxsets=${IP_NF_SET_MAX}
}

src_install() {
	einfo "Installing userspace"
	default

	find "${ED}" -name '*.la' -delete || die

	newinitd "${FILESDIR}"/ipset.initd-r5 ${PN}
	newconfd "${FILESDIR}"/ipset.confd-r1 ${PN}
	systemd_newunit "${FILESDIR}"/ipset.systemd-r1 ${PN}.service
	keepdir /var/lib/ipset
}
