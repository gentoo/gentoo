# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils user toolchain-funcs

DESCRIPTION="Network traffic analyzer with web interface"
HOMEPAGE="https://www.ntop.org/"
SRC_URI="mirror://sourceforge/ntop/${PN}/${P}-stable.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/sqlite:3
	dev-python/pyzmq
	dev-lang/luajit:2
	dev-libs/json-c:=
	dev-libs/geoip
	dev-libs/glib:2
	dev-libs/hiredis
	dev-libs/libxml2
	net-analyzer/rrdtool
	net-libs/libpcap
	net-misc/curl
	virtual/libmysqlclient
	!net-libs/nDPI"
RDEPEND="${DEPEND}
	dev-db/redis"

S="${WORKDIR}/${P}-stable"

src_prepare() {
	cat "${S}/configure.seed" | sed "s/@VERSION@/${PV}/g" | sed "s/@SHORT_VERSION@/${PV}/g" > "${S}/configure.ac"
	epatch "${FILESDIR}/${P}-dont-build-ndpi.patch"
	epatch "${FILESDIR}/${P}-mysqltool.patch"
	epatch "${FILESDIR}/${P}-cxx.patch"
	sed -i 's/exit$/exit 1/g' "${S}/configure.ac" "${S}/nDPI/configure.ac"
	eautoreconf

	cd "${S}/nDPI"
	eautoreconf
}

src_configure() {
	tc-export CC CXX LD NM OBJDUMP PKG_CONFIG
	cd "${S}/nDPI"
	econf
	cd "${S}"
	econf
}

src_compile() {
	cd "${S}/nDPI"
	emake

	cd "${S}"
	emake
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
