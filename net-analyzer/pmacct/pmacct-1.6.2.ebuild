# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="A network tool to gather IP traffic information"
HOMEPAGE="http://www.pmacct.net/"
SRC_URI="http://www.pmacct.net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="64bit debug geoip geoipv2 ipv6 jansson kafka mongodb mysql nflog postgres rabbitmq sqlite threads"
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
	mysql? ( virtual/mysql )
	nflog? ( net-libs/libnetfilter_log )
	postgres? ( dev-db/postgresql:* )
	rabbitmq? ( net-libs/rabbitmq-c )
	sqlite? ( =dev-db/sqlite-3* )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=(
	CONFIG-KEYS ChangeLog FAQS QUICKSTART TOOLS UPGRADE
	docs/INTERNALS docs/PLUGINS docs/SIGNALS
)

src_configure() {
	tc-export CC AR RANLIB

	econf \
		$(use_enable 64bit) \
		$(use_enable debug) \
		$(use_enable geoip) \
		$(use_enable geoipv2) \
		$(use_enable ipv6) \
		$(use_enable jansson) \
		$(use_enable kafka) \
		$(use_enable mongodb) \
		$(use_enable mysql) \
		$(use_enable nflog) \
		$(use_enable postgres pgsql) \
		$(use_enable rabbitmq) \
		$(use_enable sqlite sqlite3) \
		$(use_enable threads) \
		--disable-debug
}

src_install() {
	default

	for dirname in examples sql; do
		docinto ${dirname}
		dodoc -r ${dirname}/*
	done

	newinitd "${FILESDIR}"/pmacctd-init.d pmacctd
	newconfd "${FILESDIR}"/pmacctd-conf.d pmacctd

	insinto /etc/pmacctd
	newins examples/pmacctd-imt.conf.example pmacctd.conf
}
