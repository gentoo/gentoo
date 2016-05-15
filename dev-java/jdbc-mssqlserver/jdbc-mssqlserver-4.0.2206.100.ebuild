# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit java-pkg-2 versionator

MY_PN="sqljdbc"
MY_P="${MY_PN}-${PV}"
MY_ID="02AAE597-3865-456C-AE7F-613F99F850A8"

DESCRIPTION="JDBC driver for Microsoft SQL Server"
HOMEPAGE="http://msdn.microsoft.com/en-US/data/aa937724.aspx"
SRC_URI="http://download.microsoft.com/download/${MY_ID:0:1}/${MY_ID:1:1}/${MY_ID:2:1}/${MY_ID}/${MY_PN}_${PV}_enu.tar.gz"

KEYWORDS="~amd64 ~x86"
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
