# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit toolchain-funcs flag-o-matic eutils

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

pkg_setup() {
	filter-flags -ftree-vectorize
}

src_configure() {
	econf \
		$(use_enable systemd) \
		$(use_with lua) \
		$(use_with luajit) \
		$(use_with protobuf)
}

src_install() {
	dosbin pdns_recursor rec_control
	doman pdns_recursor.1 rec_control.1

	insinto /etc/powerdns
	doins "${FILESDIR}"/recursor.conf

	doinitd "${FILESDIR}"/precursor

	# Pretty ugly, uh?
	dodir /var/lib/powerdns/var/lib
	dosym ../.. /var/lib/powerdns/var/lib/powerdns
}
