# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="MiniUPnP IGD Daemon"
HOMEPAGE="http://miniupnp.free.fr/"
SRC_URI="http://miniupnp.free.fr/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+leasefile igd2 ipv6 nftables pcp-peer portinuse strict"

RDEPEND="
	dev-libs/gmp:0=
	sys-apps/util-linux:=
	dev-libs/openssl:0=
	!nftables? (
		>=net-firewall/iptables-1.4.6:0=[ipv6?]
		net-libs/libnfnetlink:=
		net-libs/libmnl:=
	)
	nftables? (
		net-firewall/nftables
		net-libs/libnftnl:=
		net-libs/libmnl:=
	)"
DEPEND="${RDEPEND}
	sys-apps/lsb-release"

src_configure() {
	local opts=(
		--vendorcfg
		$(usex igd2 '--igd2' '')
		$(usex ipv6 '--ipv6' '')
		$(usex leasefile '--leasefile' '')
		$(usex portinuse '--portinuse' '')
		$(usex pcp-peer '--pcp-peer' '')
		$(usex strict '--strict' '')
		--firewall=$(usex nftables nftables iptables)
	)

	# custom script
	./configure "${opts[@]}" || die
	# prevent gzipping manpage
	sed -i -e '/gzip/d' Makefile || die
}

src_compile() {
	# By default, it builds a bunch of unittests that are missing wrapper
	# scripts in the tarball
	emake CC="$(tc-getCC)" STRIP=true miniupnpd
}

src_install() {
	emake PREFIX="${ED}" STRIP=true install

	local confd_seds=()
	if use nftables; then
		confd_seds+=( -e 's/^iptables_scripts=/#&/' )
	else
		confd_seds+=( -e 's/^nftables_scripts=/#&/' )
	fi
	if ! use ipv6 || use nftables; then
		confd_seds+=( -e 's/^ip6tables_scripts=/#&/' )
	fi

	newinitd "${FILESDIR}"/${PN}-init.d-r2 ${PN}
	newconfd - ${PN} < <(sed "${confd_seds[@]}" \
		"${FILESDIR}"/${PN}-conf.d-r2 || die)
}

pkg_postinst() {
	elog "Please correct the external interface in the top of the two"
	elog "scripts in /etc/miniupnpd and edit the config file in there too"
}
