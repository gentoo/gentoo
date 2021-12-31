# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools user toolchain-funcs

DESCRIPTION="Network traffic analyzer with web interface"
HOMEPAGE="https://www.ntop.org/"
SRC_URI="https://github.com/ntop/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=net-libs/nDPI-3.0:=
	dev-db/mysql-connector-c:=
	dev-db/sqlite:3
	dev-libs/hiredis
	dev-libs/json-c:=
	dev-libs/libmaxminddb
	dev-libs/libsodium:=
	dev-libs/openssl
	net-analyzer/rrdtool
	net-libs/libpcap
	>=net-libs/zeromq-3:=
	net-misc/curl
	sys-libs/libcap
	sys-libs/zlib
"
RDEPEND="
	${DEPEND}
	dev-db/redis
"
BDEPEND="
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${PN}-3.8-mysqltool.patch
	"${FILESDIR}"/${PN}-3.8-ndpi-includes.patch
	"${FILESDIR}"/${PN}-3.8.1-PKG_CONFIG.patch
	"${FILESDIR}"/${PN}-3.8.1-parallel-make.patch
)
RESTRICT="test"

pkg_setup() {
	enewuser ntopng
}

src_prepare() {
	default

	sed \
		-e "s/@VERSION@/${PV}.$(date +%y%m%d)/g" \
		-e "s/@SHORT_VERSION@/${PV}/g" \
		< "${S}/configure.seed" \
		> "${S}/configure.ac" || die

	eautoreconf
}

src_configure() {
	tc-export PKG_CONFIG
	default
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		MYCFLAGS="${CFLAGS}" \
		MYLDFLAGS="${LDFLAGS}"
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

	newinitd "${FILESDIR}"/ntopng.init.d ntopng
	newconfd "${FILESDIR}"/ntopng.conf.d ntopng

	keepdir /var/lib/ntopng
	fowners ntopng /var/lib/ntopng
}

pkg_postinst() {
	elog "ntopng default credentials are user='admin' password='admin'"
}
