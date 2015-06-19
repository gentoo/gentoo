# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jdbc-mssqlserver/jdbc-mssqlserver-4.0.2206.100.ebuild,v 1.2 2012/10/14 18:48:21 thev00d00 Exp $

EAPI="4"

inherit java-pkg-2 versionator

MY_PN="sqljdbc"
MY_P="${MY_PN}-${PV}"
MY_ID="02AAE597-3865-456C-AE7F-613F99F850A8"

DESCRIPTION="JDBC driver for Microsoft SQL Server"
HOMEPAGE="http://msdn.microsoft.com/en-US/data/aa937724.aspx"
SRC_URI="http://download.microsoft.com/download/${MY_ID:0:1}/${MY_ID:1:1}/${MY_ID:2:1}/${MY_ID}/${MY_PN}_${PV}_enu.tar.gz"

KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="MSjdbcEULA40"
SLOT="4.0"

IUSE="doc"

DEPEND=""
RDEPEND=">=virtual/jre-1.6"

RESTRICT="mirror"

S="${WORKDIR}/${MY_PN}_$(get_version_component_range 1-2)/enu"

src_install() {
	dodoc release.txt || die
	if use doc; then
		dohtml -r help/*
	fi
	java-pkg_dojar *.jar
}
