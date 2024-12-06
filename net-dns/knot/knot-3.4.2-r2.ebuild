# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic systemd tmpfiles

# subslot: libknot major.libdnssec major.libzscanner major
KNOT_SUBSLOT="15.9.4"

DESCRIPTION="High-performance authoritative-only DNS server"
HOMEPAGE="https://www.knot-dns.cz/ https://gitlab.nic.cz/knot/knot-dns"
SRC_URI="https://secure.nic.cz/files/knot-dns/${P/_/-}.tar.xz"

S="${WORKDIR}/${P/_/-}"

LICENSE="GPL-3+"
SLOT="0/${KNOT_SUBSLOT}"
KEYWORDS="~amd64 ~riscv ~x86"

KNOT_MODULES=(
	"+authsignal"
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

IUSE="caps +daemon dbus +doc doh +fastparser +idn pkcs11 quic systemd test +utils xdp ${KNOT_MODULES[@]}"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/libedit
	dnstap? (
		dev-libs/fstrm
		dev-libs/protobuf-c:=
	)
	quic? ( net-libs/ngtcp2[gnutls] )
"
RDEPEND="
	dev-db/lmdb:=
	net-libs/gnutls:=[pkcs11?]
	daemon? (
		${COMMON_DEPEND}
		acct-group/knot
		acct-user/knot
		dev-libs/userspace-rcu:=
		caps? ( sys-libs/libcap-ng )
		dbus? ( sys-apps/dbus )
		geoip? ( dev-libs/libmaxminddb:= )
		systemd? ( sys-apps/systemd:= )
		)
	utils? (
		${COMMON_DEPEND}
		doh? ( net-libs/nghttp2:= )
		idn? ( net-dns/libidn2:= )
	)
	xdp? (
		>=dev-libs/libbpf-1.0:=
		net-libs/xdp-tools
		utils? ( net-libs/libmnl:= )
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( dev-python/sphinx )
	test? (
		pkcs11? ( dev-libs/softhsm )
	)
"

src_prepare() {
	default

	# these tests call this daemon file knot/server/dthreads.h
	if use test && use !daemon; then
		sed -i \
		-e '/test_atomic/d' \
		-e '/test_spinlock/d' \
		tests/Makefile.am || die
		eautoreconf
	fi
}

src_configure() {
	local u
	local my_conf=(
		--with-storage="${EPREFIX}/var/lib/${PN}"
		--with-rundir="${EPREFIX}/var/run/${PN}"
		$(use_enable caps cap_ng)
		$(use_enable daemon)
		$(use_enable fastparser)
		$(use_enable dnstap)
		$(use_enable doc documentation)
		$(use_with doh libnghttp2)
		$(use_enable geoip maxminddb)
		$(use_with idn libidn)
		$(use_enable quic)
		$(use_enable systemd)
		$(use_enable utils utilities)
		$(use_enable xdp)
	)

	# modules (except dnstap forced by use_enable if set with utils) are only used by daemon
	if use daemon; then
		for u in "${KNOT_MODULES[@]#+}"; do
			my_conf+=("$(use_with ${u} module-${u})")
		done
	else
			my_conf+=("--disable-modules")
	fi

	if use !daemon; then
		my_conf+=("--enable-dbus=no")
	elif use dbus; then
		my_conf+=("--enable-dbus=libdbus")
	elif use !dbus && use !systemd; then
		my_conf+=("--enable-dbus=no")
	elif use !dbus && use systemd; then
		my_conf+=("--enable-dbus=systemd")
	fi

	if use riscv; then
		append-libs -latomic
	fi

	econf "${my_conf[@]}"
}

src_compile() {
	default

	use doc && emake -C doc html
}

src_install() {
	use doc && local HTML_DOCS=( doc/_build/html/{*.html,*.js,_sources,_static} )

	default

	if use daemon; then
		rmdir "${D}/var/run/${PN}" "${D}/var/run/" || die

		newinitd "${FILESDIR}"/knot-3.init knot
		newconfd "${FILESDIR}"/knot.confd knot

		newtmpfiles "${FILESDIR}"/${PN}.tmpfile ${PN}.conf

		use systemd && systemd_newunit distro/common/knot.service knot.service
	fi

	find "${D}" -name '*.la' -delete || die

	keepdir /var/lib/knot
}

pkg_postinst() {
	use daemon && tmpfiles_process ${PN}.conf
}
