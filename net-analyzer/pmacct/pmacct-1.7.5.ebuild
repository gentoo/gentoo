# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="A network tool to gather IP traffic information"
HOMEPAGE="http://www.pmacct.net/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="
	+bgp-bins +bmp-bins geoip geoipv2 jansson kafka +l2 mysql ndpi nflog plabel
	postgres rabbitmq sqlite +st-bins +traffic-bins zmq
"
REQUIRED_USE="
	?? ( geoip geoipv2 )
	kafka? ( jansson )
	rabbitmq? ( jansson )
"

RDEPEND="
	net-libs/libpcap
	geoip? ( dev-libs/geoip )
	geoipv2? ( dev-libs/libmaxminddb )
	jansson? ( dev-libs/jansson )
	kafka? ( dev-libs/librdkafka )
	mysql? ( dev-db/mysql-connector-c:0= )
	ndpi? ( >=net-libs/nDPI-3.2:= )
	nflog? ( net-libs/libnetfilter_log )
	postgres? ( dev-db/postgresql:* )
	rabbitmq? ( net-libs/rabbitmq-c )
	sqlite? ( =dev-db/sqlite-3* )
	zmq? ( >=net-libs/zeromq-4.2.0:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.7.4--Werror.patch
)

DOCS=(
	CONFIG-KEYS ChangeLog FAQS QUICKSTART UPGRADE
	docs/INTERNALS docs/PLUGINS docs/SIGNALS
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	tc-export CC AR RANLIB
	append-cflags -fcommon

	econf \
		$(use_enable bgp-bins) \
		$(use_enable bmp-bins) \
		$(use_enable geoip) \
		$(use_enable geoipv2) \
		$(use_enable jansson) \
		$(use_enable kafka) \
		$(use_enable l2) \
		$(use_enable mysql) \
		$(use_enable ndpi) \
		$(use_enable nflog) \
		$(use_enable plabel) \
		$(use_enable postgres pgsql) \
		$(use_enable rabbitmq) \
		$(use_enable sqlite sqlite3) \
		$(use_enable st-bins) \
		$(use_enable traffic-bins) \
		$(use_enable zmq) \
		--disable-debug \
		--disable-mongodb
}

src_install() {
	default

	for dirname in examples sql telemetry; do
		docinto ${dirname}
		dodoc -r ${dirname}/*
	done

	newinitd "${FILESDIR}"/pmacctd-init.d pmacctd
	newconfd "${FILESDIR}"/pmacctd-conf.d pmacctd

	insinto /etc/pmacctd
	newins examples/pmacctd-imt.conf.example pmacctd.conf
}
