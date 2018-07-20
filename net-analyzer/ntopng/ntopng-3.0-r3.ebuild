# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools user toolchain-funcs

DESCRIPTION="Network traffic analyzer with web interface"
HOMEPAGE="https://www.ntop.org/"
SRC_URI="https://github.com/ntop/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-db/sqlite:3
	dev-python/pyzmq
	dev-lang/luajit:2
	dev-libs/json-c:=
	dev-libs/geoip
	dev-libs/glib:2
	dev-libs/hiredis
	dev-libs/libsodium:=
	dev-libs/libxml2
	net-analyzer/rrdtool
	net-libs/libpcap
	=net-libs/nDPI-2.0
	net-misc/curl
	sys-libs/binutils-libs:=
	virtual/libmysqlclient"
RDEPEND="${DEPEND}
	dev-db/redis"
PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-mysqltool.patch
	"${FILESDIR}"/${P}-pointer-cmp.patch
)

src_prepare() {
	sed -e "s/@VERSION@/${PV}/g;s/@SHORT_VERSION@/${PV}/g" < "${S}/configure.seed" > "${S}/configure.ac" || die

	default

	eautoreconf
}

src_install() {
	SHARE_NTOPNG_DIR="${EPREFIX}/usr/share/${PN}"
	dodir ${SHARE_NTOPNG_DIR}
	insinto ${SHARE_NTOPNG_DIR}
	doins -r httpdocs
	doins -r scripts

	dodir ${SHARE_NTOPNG_DIR}/third-party
	insinto ${SHARE_NTOPNG_DIR}/third-party
	doins -r third-party/i18n.lua-master
	doins -r third-party/lua-resty-template-master

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
	elog "ntopng default credentials are user='admin' password='admin'"
}
