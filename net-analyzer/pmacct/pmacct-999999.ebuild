# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic git-r3 toolchain-funcs

DESCRIPTION="A network tool to gather IP traffic information"
HOMEPAGE="http://www.pmacct.net/"
EGIT_REPO_URI="https://github.com/pmacct/pmacct/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="
	+bgp-bins +bmp-bins geoip geoipv2 jansson kafka +l2 mongodb mysql
	ndpi nflog plabel postgres rabbitmq sqlite +st-bins +traffic-bins zmq
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
	mongodb? (
		>=dev-libs/mongo-c-driver-0.8.1-r1
		<dev-libs/mongo-c-driver-0.98
	)
	mysql? ( dev-db/mysql-connector-c:0= )
	ndpi? ( >=net-libs/nDPI-3.0:= )
	nflog? ( net-libs/libnetfilter_log )
	postgres? ( dev-db/postgresql:* )
	rabbitmq? ( net-libs/rabbitmq-c )
	sqlite? ( =dev-db/sqlite-3* )
	zmq? ( >=net-libs/zeromq-4.2.0:= )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=(
	CONFIG-KEYS ChangeLog FAQS QUICKSTART UPGRADE
	docs/INTERNALS docs/PLUGINS docs/SIGNALS
)

src_prepare() {
	default
	sed -i -e 's|-Werror||g' configure.ac || die
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
		$(use_enable plabel) \
		$(use_enable mongodb) \
		$(use_enable mysql) \
		$(use_enable ndpi) \
		$(use_enable nflog) \
		$(use_enable postgres pgsql) \
		$(use_enable rabbitmq) \
		$(use_enable sqlite sqlite3) \
		$(use_enable st-bins) \
		$(use_enable traffic-bins) \
		$(use_enable zmq) \
		--disable-debug
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
