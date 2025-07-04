# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit autotools python-r1 flag-o-matic systemd tmpfiles verify-sig

# subslot: libknot major.libdnssec major.libzscanner major
KNOT_SUBSLOT="15.9.4"

DESCRIPTION="High-performance authoritative-only DNS server"
HOMEPAGE="https://www.knot-dns.cz/ https://gitlab.nic.cz/knot/knot-dns"
SRC_URI="
	https://knot-dns.nic.cz/release/${P}.tar.xz
	!doc? ( https://raw.githubusercontent.com/PPN-SD/gentoo-manpages/refs/tags/${P}/${P}-manpages.tar.xz )
	verify-sig? ( https://knot-dns.nic.cz/release/${P}.tar.xz.asc )
"

LICENSE="GPL-3+"
SLOT="0/${KNOT_SUBSLOT}"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

# Modules without dep. Built unconditionally.
KNOT_MODULES=(
	"authsignal"
	"cookies"
	"dnsproxy"
	"noudp"
	"onlinesign"
	"queryacl"
	"rrl"
	"stats"
	"synthrecord"
	"whoami"
)

KNOT_MODULES_OPT=(
	"dnstap"
	"geoip"
)

IUSE="caps +daemon dbus doc doh +fastparser +idn pkcs11 prometheus python quic selinux systemd test +utils xdp ${KNOT_MODULES_OPT[@]}"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	prometheus? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
"

COMMON_DEPEND="
	dev-libs/libedit
	dnstap? (
		dev-libs/fstrm
		dev-libs/protobuf-c:=
	)
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
	prometheus? (
		dev-python/prometheus-client[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	)
	python? ( ${PYTHON_DEPS} )
	quic? ( net-libs/ngtcp2[gnutls] )
	selinux? ( sec-policy/selinux-knot )
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
	doc? (
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-panels[${PYTHON_USEDEP}]
		')
	)
	python? ( ${PYTHON_DEPS} )
	test? (
		pkcs11? ( dev-libs/softhsm )
	)
	verify-sig? ( sec-keys/openpgp-keys-knot )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/${PN}.asc

# Used to check cpuset_t in sched.h with NetBSD.
# False positive because linux have sched.h too but with cpu_set_t
QA_CONFIG_IMPL_DECL_SKIP=( cpuset_create cpuset_destroy )

python_check_deps() {
	use doc || return 0
	python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]" \
		"dev-python/sphinx-panels[${PYTHON_USEDEP}]"
}

pkg_setup() {
	if use doc || use python; then
		python_setup
	fi
}

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.xz{,.asc}
	fi
	default
}

src_prepare() {
	default
	# avoid the old ltmain.sh modified by upstream which causes a linking issue
	# reproduced with test and musl
	eautoreconf
}

src_configure() {
	local u
	local my_conf=(
		--with-storage="${EPREFIX}/var/lib/${PN}"
		--with-rundir="${EPREFIX}/var/run/${PN}"
		$(use_enable caps cap_ng)
		$(use_enable daemon)
		# enable-dnstap defines support for kdig only
		$(use_enable dnstap dnstap $(usex utils))
		$(use_enable doc documentation)
		$(use_with doh libnghttp2)
		$(use_enable fastparser)
		$(use_enable geoip maxminddb)
		$(use_with idn libidn)
		$(use_enable quic)
		$(use_enable systemd)
		$(use_enable utils utilities)
		$(use_enable xdp)
	)
	# modules are only used by daemon
	# module-dnstap defines support for knotd only
	if use daemon; then
		for u in "${KNOT_MODULES[@]}"; do
			my_conf+=("--with-module-${u}")
		done
		for u in "${KNOT_MODULES_OPT[@]#+}"; do
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
	if use doc; then
		local HTML_DOCS=( doc/_build/html/{*.html,*.js,_sources,_static} )
	else
		doman "${WORKDIR}"/man/*
	fi

	if use python; then
		python_foreach_impl python_domodule python/libknot/libknot
		newdoc python/libknot/README.md README.python.md
	fi

	if use prometheus; then
		python_foreach_impl python_domodule python/knot_exporter/knot_exporter
		python_scriptinto /usr/sbin
		python_foreach_impl python_newscript python/knot_exporter/knot_exporter/knot_exporter.py knot-exporter
		newdoc python/knot_exporter/README.md README.knot_exporter.md
	fi

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
