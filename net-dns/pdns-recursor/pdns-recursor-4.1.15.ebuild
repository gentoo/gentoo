# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic

DESCRIPTION="The PowerDNS Recursor"
HOMEPAGE="https://www.powerdns.com/"
SRC_URI="https://downloads.powerdns.com/releases/${P/_/-}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug libressl luajit protobuf snmp sodium systemd"

DEPEND="!luajit? ( >=dev-lang/lua-5.1:= )
	luajit? ( dev-lang/luajit:= )
	protobuf? (
		dev-libs/protobuf
		>=dev-libs/boost-1.42:=
	)
	systemd? ( sys-apps/systemd:0= )
	snmp? ( net-analyzer/net-snmp )
	sodium? ( dev-libs/libsodium:= )
	libressl? ( dev-libs/libressl:= )
	!libressl? ( dev-libs/openssl:= )
	>=dev-libs/boost-1.35:="
RDEPEND="${DEPEND}
	!<net-dns/pdns-2.9.20-r1"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}"/${P/_/-}

pkg_setup() {
	filter-flags -ftree-vectorize
}

src_configure() {
	econf \
		--sysconfdir=/etc/powerdns \
		$(use_enable debug verbose-logging) \
		$(use_enable systemd) \
		$(use_enable sodium libsodium) \
		$(use_with !luajit lua) \
		$(use_with luajit luajit) \
		$(use_with protobuf) \
		$(use_with snmp net-snmp)
}

src_install() {
	default

	mv "${D}"/etc/powerdns/recursor.conf{-dist,}

	# set defaults: setuid=nobody, setgid=nobody
	sed -i \
		-e 's/^# set\([ug]\)id=$/set\1id=nobody/' \
		-e 's/^# quiet=$/quiet=on/' \
		-e 's/^# chroot=$/chroot=\/var\/lib\/powerdns/' \
		"${D}"/etc/powerdns/recursor.conf

	newinitd "${FILESDIR}"/pdns-recursor-r1 pdns-recursor

	keepdir /var/lib/powerdns
}

pkg_postinst() {
	local old

	for old in ${REPLACING_VERSIONS}; do
		ver_test ${old} -lt 4.0.0-r1 || continue

		ewarn "Starting with 4.0.0-r1 the init script has been renamed from precursor"
		ewarn "to pdns-recursor, please update your runlevels accordingly."

		break
	done
}
