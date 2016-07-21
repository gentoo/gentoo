# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="A network tool to gather IP traffic information"
HOMEPAGE="http://www.pmacct.net/"
SRC_URI="https://dev.gentoo.org/~jer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="64bit debug geoip geoipv2 ipv6 mongodb mysql postgres sqlite threads ulog"
REQUIRED_USE="
	?? ( geoip geoipv2 )
"

RDEPEND="
	net-libs/libpcap
	geoip? ( dev-libs/geoip )
	geoipv2? ( dev-libs/libmaxminddb )
	mongodb? (
		>=dev-libs/mongo-c-driver-0.8.1-r1
		<dev-libs/mongo-c-driver-0.98
	)
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( =dev-db/sqlite-3* )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/pmacct-daily"

DOCS=(
	CONFIG-KEYS ChangeLog FAQS KNOWN-BUGS QUICKSTART README TODO TOOLS UPGRADE
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
		$(use_enable mongodb) \
		$(use_enable mysql) \
		$(use_enable postgres pgsql) \
		$(use_enable sqlite sqlite3) \
		$(use_enable threads) \
		$(use_enable ulog) \
		$(usex mysql "--with-mysql-includes=$(mysql_config --variable=pkgincludedir)" '') \
		$(usex mysql "--with-mysql-libs=$(mysql_config --variable=pkglibdir)" '') \
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
