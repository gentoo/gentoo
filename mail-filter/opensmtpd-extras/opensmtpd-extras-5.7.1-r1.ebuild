# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic autotools

DESCRIPTION="Extra tables, filters, and various other addons for OpenSMTPD"
HOMEPAGE="https://github.com/OpenSMTPD/OpenSMTPD-extras"
SRC_URI="https://www.opensmtpd.org/archives/${P}.tar.gz"

LICENSE="ISC BSD BSD-1 BSD-2 BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
MY_COMPONENTS="
	filter-clamav
	filter-dkim-signer
	filter-dnsbl
	filter-lua
	filter-monkey
	filter-pause
	filter-perl
	filter-python
	filter-regex
	filter-spamassassin
	filter-stub
	filter-trace
	filter-void

	queue-null
	queue-python
	queue-ram
	queue-stub

	scheduler-python
	scheduler-ram
	scheduler-stub

	table-ldap
	table-mysql
	table-passwd
	table-postgres
	table-python
	table-redis
	table-socketmap
	table-sqlite
	table-stub
"
IUSE="${MY_COMPONENTS} libressl luajit"

# Deps:
# mysql needs -lmysqlclient
# sqlite needs -lsqlite3
# redis needs -lhiredis
# postgres requires -lpq
# ldap uses internal library and requires no deps
# spamassassin uses internal library and requires no deps
# clamav uses internal library and requires no deps
# dnsbl needs -lasr
# python requires python, currently pegged at 2.7
# lua requires any lua version

DEPEND="mail-mta/opensmtpd
	dev-libs/libevent
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	filter-python? ( dev-lang/python:2.7 )
	filter-perl? ( dev-lang/perl )
	filter-lua? ( luajit? ( dev-lang/luajit:2 ) !luajit? ( dev-lang/lua:* ) )
	filter-dnsbl? ( net-libs/libasr )
	table-sqlite? ( dev-db/sqlite:3 )
	table-mysql? ( virtual/mysql )
	table-postgres? ( dev-db/postgresql:* )
	table-redis? ( dev-libs/hiredis )
	table-python? ( dev-lang/python:2.7 )
	scheduler-python? ( dev-lang/python:2.7 )
	queue-python? ( dev-lang/python:2.7 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}
src_configure() {
	econf \
		--with-privsep-user=smtpd \
		--with-privsep-path=/var/empty \
		--sysconfdir=/etc/opensmtpd \
		--with-lua-type=$(usex luajit luajit lua) \
		$(for use in $MY_COMPONENTS; do use_with $use; done)
}
