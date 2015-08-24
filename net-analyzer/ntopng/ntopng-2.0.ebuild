# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools user

DESCRIPTION="Network traffic analyzer with web interface"
HOMEPAGE="http://www.ntop.org/"
SRC_URI="mirror://sourceforge/ntop/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/sqlite:3
	dev-lang/luajit:2
	dev-libs/geoip
	dev-libs/glib:2
	dev-libs/libxml2
	net-analyzer/rrdtool
	net-libs/libpcap
	net-libs/zeromq"
RDEPEND="${DEPEND}
	dev-db/redis"

src_prepare() {
	cat "${S}/configure.seed" | sed "s/@VERSION@/${PV}/g" | sed "s/@SHORT_VERSION@/${PV}/g" > "${S}/configure.ac"
	eautoreconf
}

src_install() {
	SHARE_NTOPNG_DIR="${EPREFIX}/usr/share/${PN}"
	dodir ${SHARE_NTOPNG_DIR}
	insinto ${SHARE_NTOPNG_DIR}
	doins -r httpdocs
	doins -r scripts

	exeinto /usr/bin
	doexe ${PN}
	doman ${PN}.8

	newinitd "${FILESDIR}/ntopng.init.d" ntopng
	newconfd "${FILESDIR}/ntopng.conf.d" ntopng

	dodir "/var/lib/ntopng"
	fowners ntopng "${EPREFIX}/var/lib/ntopng"
}

pkg_setup() {
	enewuser ntopng
}

pkg_postinst() {
	elog "ntopng default creadential are user='admin' password='admin'"
}
