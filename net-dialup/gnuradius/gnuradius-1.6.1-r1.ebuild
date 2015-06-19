# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/gnuradius/gnuradius-1.6.1-r1.ebuild,v 1.4 2014/12/28 16:15:33 titanofold Exp $

EAPI=5

inherit eutils multilib pam

MY_P="${P#gnu}"

DESCRIPTION="GNU radius authentication server"
HOMEPAGE="http://www.gnu.org/software/radius/radius.html"
SRC_URI="mirror://gnu/radius/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="
	dbm debug guile mysql nls odbc postgres readline snmp static-libs
"

DEPEND="
	!net-dialup/cistronradius
	!net-dialup/freeradius
	dbm? ( sys-libs/gdbm )
	guile? ( >=dev-scheme/guile-1.4 )
	mysql? ( virtual/mysql )
	odbc? ( || ( dev-db/unixODBC dev-db/libiodbc ) )
	postgres? ( dev-db/postgresql[server] )
	readline? ( sys-libs/readline )
	snmp? ( net-analyzer/net-snmp )
	virtual/pam
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/${P}-qa-false-positives.patch
}

src_configure() {
	econf \
		--disable-maintainer-mode \
		--enable-client \
		--enable-pam \
		--enable-server \
		--libdir=/usr/$(get_libdir) \
		--with-pamdir=/usr/$(getpam_mod_dir) \
		$(use_enable dbm) \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable snmp) \
		$(use_enable static-libs static) \
		$(use_with guile) \
		$(use_with guile server-guile) \
		$(use_with mysql) \
		$(use_with odbc) \
		$(use_with postgres) \
		$(use_with readline)
}

src_install() {
	default

	prune_libtool_files
}
