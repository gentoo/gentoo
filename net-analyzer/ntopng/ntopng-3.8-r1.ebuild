# Copyright 1999-2019 Gentoo Authors
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
	dev-libs/libmaxminddb
	net-analyzer/rrdtool
	net-libs/libpcap
	>=net-libs/nDPI-2.4:=
	net-misc/curl
	sys-libs/binutils-libs
	dev-db/mysql-connector-c:="
RDEPEND="${DEPEND}
	dev-db/redis"
PATCHES=(
	"${FILESDIR}"/${P}-mysqltool.patch
	"${FILESDIR}"/${P}-ndpi-includes.patch
	"${FILESDIR}"/${P}-missing-min.patch
	"${FILESDIR}"/${P}-ndpi-call.patch
)

src_prepare() {
	default
	sed -e "s/@VERSION@/${PV}.$(date +%y%m%d)/g" -e "s/@SHORT_VERSION@/${PV}/g" < "${S}/configure.seed" > "${S}/configure.ac" > configure.ac
	eapply_user
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
	fowners ntopng "/var/lib/ntopng"
}

pkg_setup() {
	enewuser ntopng
}

pkg_postinst() {
	elog "ntopng default credentials are user='admin' password='admin'"
}
