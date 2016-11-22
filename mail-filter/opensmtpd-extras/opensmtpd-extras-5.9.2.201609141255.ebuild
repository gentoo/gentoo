# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic autotools versionator

DESCRIPTION="Extra tables, filters, and various other addons for OpenSMTPD"
HOMEPAGE="https://github.com/OpenSMTPD/OpenSMTPD-extras"
SRC_URI="https://www.opensmtpd.org/archives/${PN}-$(get_version_component_range 4-).tar.gz"

LICENSE="ISC BSD BSD-1 BSD-2 BSD-4"
SLOT="0"
KEYWORDS=""
MY_COMPONENTS="
	filter-monkey
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

#filter-python? ( dev-lang/python:2.7 )
#filter-perl? ( dev-lang/perl )
#filter-dnsbl? ( net-libs/libasr )
#filter-lua? ( luajit? ( dev-lang/luajit:2 ) !luajit? ( dev-lang/lua:* ) )
DEPEND="mail-mta/opensmtpd
	dev-libs/libevent
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	table-sqlite? ( dev-db/sqlite:3 )
	table-mysql? ( virtual/mysql )
	table-postgres? ( dev-db/postgresql:* )
	table-redis? ( dev-libs/hiredis )
	table-python? ( dev-lang/python:2.7 )
	scheduler-python? ( dev-lang/python:2.7 )
	queue-python? ( dev-lang/python:2.7 )
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-$(get_version_component_range 4-)

src_prepare() {
	eautoreconf
}
src_configure() {
	econf $(for use in $MY_COMPONENTS; do use_with $use; done) \
		--with-user-smtpd=smtpd \
		--sysconfdir=/etc/opensmtpd
		#--with-lua-type=$(usex luajit luajit lua) \
}
