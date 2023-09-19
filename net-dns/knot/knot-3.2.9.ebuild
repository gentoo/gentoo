# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic systemd

# subslot: libknot major.libdnssec major.libzscanner major
KNOT_SUBSLOT="13.9.4"

DESCRIPTION="High-performance authoritative-only DNS server"
HOMEPAGE="https://www.knot-dns.cz/ https://gitlab.nic.cz/knot/knot-dns"
SRC_URI="https://secure.nic.cz/files/knot-dns/${P/_/-}.tar.xz"

LICENSE="GPL-3+"
SLOT="0/${KNOT_SUBSLOT}"
KEYWORDS="~amd64 ~riscv ~x86"

KNOT_MODULES=(
	"+cookies"
	"+dnsproxy"
	"dnstap"
	"geoip"
	"+noudp"
	"+onlinesign"
	"+queryacl"
	"+rrl"
	"+stats"
	"+synthrecord"
	"+whoami"
)
IUSE="doc caps doh +fastparser idn +libidn2 quic systemd +utils xdp ${KNOT_MODULES[@]}"

RDEPEND="
	acct-group/knot
	acct-user/knot
	dev-db/lmdb:=
	dev-libs/libedit
	dev-libs/userspace-rcu:=
	dev-python/lmdb:=
	net-libs/gnutls:=
	caps? ( sys-libs/libcap-ng )
	dnstap? (
		dev-libs/fstrm
		dev-libs/protobuf-c:=
	)
	doh? ( net-libs/nghttp2:= )
	geoip? ( dev-libs/libmaxminddb:= )
	idn? (
		!libidn2? ( net-dns/libidn:0= !net-dns/libidn2 )
		libidn2? ( net-dns/libidn2:= )
	)
	quic? ( >=net-libs/ngtcp2-0.13.1:=[gnutls] )
	systemd? ( sys-apps/systemd:= )
	xdp? (
		 dev-libs/libbpf:=
		 net-libs/libmnl:=
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( dev-python/sphinx )
"

S="${WORKDIR}/${P/_/-}"

src_configure() {
	local u
	local my_conf=(
		--with-storage="${EPREFIX}/var/lib/${PN}"
		--with-rundir="${EPREFIX}/var/run/${PN}"
		$(use_enable caps cap_ng)
		$(use_enable fastparser)
		$(use_enable dnstap)
		$(use_enable doc documentation)
		$(use_enable quic)
		$(use_enable utils utilities)
		$(use_enable xdp)
		--enable-systemd=$(usex systemd)
		$(use_with idn libidn)
		$(use_with doh libnghttp2)
	)

	for u in "${KNOT_MODULES[@]#+}"; do
		my_conf+=("$(use_with ${u} module-${u})")
	done

	if use riscv; then
		append-libs -latomic
	fi

	econf "${my_conf[@]}"
}

src_compile() {
	default

	use doc && emake -C doc html
}

src_test() {
	emake check
}

src_install() {
	use doc && local HTML_DOCS=( doc/_build/html/{*.html,*.js,_sources,_static} )

	default

	rmdir "${D}/var/run/${PN}" "${D}/var/run/" || die

	newinitd "${FILESDIR}/knot.init" knot
	if use systemd; then
		systemd_newunit "${FILESDIR}/knot-1.service" knot.service
	fi

	find "${D}" -name '*.la' -delete || die

	keepdir /var/lib/knot
}
