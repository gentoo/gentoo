# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils systemd

DESCRIPTION="Bus communication for all Prelude modules"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/3.0.0/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tcpwrapper xml geoip dbx"

RDEPEND="net-libs/gnutls
	dev-libs/libprelude
	dbx? ( dev-libs/libpreludedb )
	tcpwrapper? ( sys-apps/tcp-wrappers )
	xml? ( dev-libs/libxml2 )
	geoip? ( dev-libs/libmaxminddb )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-conf.patch"
	"${FILESDIR}/${P}-configure.patch"
	"${FILESDIR}/${P}-run.patch"
)

src_prepare() {
	default_src_prepare

	mv "${S}/configure.in" "${S}/configure.ac" || die "mv failed"

	eautoreconf
}

src_configure() {
	econf \
		--localstatedir=/var \
		$(use_enable dbx libpreludedb) \
		$(use_with tcpwrapper libwrap) \
		$(use_enable xml xmlmod) \
		$(use_enable geoip libmaxminddb)
}

src_install() {
	default_src_install

	rm -rv "${D}/run" || die "rm failed"
	keepdir /var/spool/prelude-manager{,/failover,/scheduler}

	prune_libtool_files --modules

	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_newtmpfilesd "${FILESDIR}/${PN}.run" "${PN}.conf"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
}
