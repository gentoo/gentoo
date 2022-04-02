# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit flag-o-matic lua-single

DESCRIPTION="The PowerDNS Recursor"
HOMEPAGE="https://www.powerdns.com/"
SRC_URI="https://downloads.powerdns.com/releases/${P/_/-}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug dnstap snmp sodium systemd test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="${LUA_DEPS}
	dnstap? ( dev-libs/fstrm )
	systemd? ( sys-apps/systemd:0= )
	snmp? ( net-analyzer/net-snmp )
	sodium? ( dev-libs/libsodium:= )
	elibc_glibc? (
		arm? ( >=sys-libs/glibc-2.34 )
		x86? ( >=sys-libs/glibc-2.34 )
	)
	dev-libs/openssl:=
	>=dev-libs/boost-1.35:=[context]"
RDEPEND="${DEPEND}
	!<net-dns/pdns-2.9.20-r1
	acct-user/pdns
	acct-group/pdns"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}"/${P/_/-}

PATCHES=(
	"${FILESDIR}"/${P}-parseACL.patch
)

pkg_setup() {
	lua-single_pkg_setup
	filter-flags -ftree-vectorize
	append-lfs-flags
	append-cppflags -D_TIME_BITS=64
}

src_configure() {
	econf \
		--sysconfdir=/etc/powerdns \
		--with-nod-cache-dir=/var/lib/powerdns \
		--with-service-user=pdns \
		--with-service-group=pdns \
		--with-lua="${ELUA}" \
		$(use_enable debug verbose-logging) \
		$(use_enable systemd) \
		$(use_enable dnstap dnstap) \
		$(use_enable test unit-tests) \
		$(use_with sodium libsodium) \
		$(use_with snmp net-snmp)
}

src_install() {
	default

	mv "${D}"/etc/powerdns/recursor.conf{-dist,}

	# set defaults: setuid=nobody, setgid=nobody
	sed -i \
		-e 's/^# set\([ug]\)id=$/set\1id=pdns/' \
		-e 's/^# quiet=$/quiet=on/' \
		-e 's/^# chroot=$/chroot=\/var\/lib\/powerdns/' \
		"${D}"/etc/powerdns/recursor.conf

	newinitd "${FILESDIR}"/pdns-recursor-r2 pdns-recursor
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
