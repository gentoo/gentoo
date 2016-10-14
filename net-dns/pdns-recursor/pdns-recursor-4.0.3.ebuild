# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit toolchain-funcs flag-o-matic eutils versionator

DESCRIPTION="The PowerDNS Recursor"
HOMEPAGE="http://www.powerdns.com/"
SRC_URI="http://downloads.powerdns.com/releases/${P/_/-}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="lua luajit protobuf systemd"
REQUIRED_USE="?? ( lua luajit )"

DEPEND="lua? ( >=dev-lang/lua-5.1:= )
	luajit? ( dev-lang/luajit:= )
	protobuf? (
		dev-libs/protobuf
		>=dev-libs/boost-1.42
	)
	>=dev-libs/boost-1.35"
RDEPEND="${DEPEND}
	!<net-dns/pdns-2.9.20-r1"
DEPEND="${DEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"/${P/_/-}

PATCHES=(
	"${FILESDIR}"/${P}-boost-1.61-fcontext.patch
)

pkg_setup() {
	filter-flags -ftree-vectorize
}

src_configure() {
	econf \
		--sysconfdir=/etc/powerdns \
		$(use_enable systemd) \
		$(use_with lua) \
		$(use_with luajit) \
		$(use_with protobuf)
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

	doinitd "${FILESDIR}"/pdns-recursor

	keepdir /var/lib/powerdns
}

pkg_postinst() {
	local old

	for old in ${REPLACING_VERSIONS}; do
		version_compare ${old} 4.0.0-r1
		[[ $? -eq 1 ]] || continue

		ewarn "Starting with 4.0.0-r1 the init script has been renamed from precursor"
		ewarn "to pdns-recursor, please update your runlevels accordingly."

		break
	done
}
