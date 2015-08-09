# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="A network tool to gather IP traffic information"
HOMEPAGE="http://www.pmacct.net/"
SRC_URI="http://www.pmacct.net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="64bit debug geoip ipv6 mongodb mysql postgres sqlite threads ulog"

DEPEND="
	net-libs/libpcap
	geoip? ( dev-libs/geoip )
	mongodb? ( dev-libs/mongo-c-driver )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	sqlite? ( =dev-db/sqlite-3* )
"
RDEPEND="${DEPEND}"

DOCS=(
	CONFIG-KEYS ChangeLog FAQS KNOWN-BUGS QUICKSTART README TODO TOOLS UPGRADE
	docs/INTERNALS docs/PLUGINS docs/SIGNALS
)

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.12.0-gentoo.patch
	sed -i \
		-e '/[[:space:]]ar /s|ar |$(AR) |g' \
		$(find . -name Makefile.in) || die
}

src_configure() {
	tc-export CC AR RANLIB

	econf \
		$(use_enable 64bit) \
		$(use_enable debug) \
		$(use_enable geoip) \
		$(use_enable ipv6) \
		$(use_enable mongodb) \
		$(use_enable mysql) \
		$(use_enable postgres pgsql) \
		$(use_enable sqlite sqlite3) \
		$(use_enable threads) \
		$(use_enable ulog)
}

src_install() {
	default

	for dirname in examples sql; do
		docinto ${dirname}
		dodoc ${dirname}/*
	done

	newinitd "${FILESDIR}"/pmacctd-init.d pmacctd
	newconfd "${FILESDIR}"/pmacctd-conf.d pmacctd

	insinto /etc/pmacctd
	newins examples/pmacctd-imt.conf.example pmacctd.conf
}
