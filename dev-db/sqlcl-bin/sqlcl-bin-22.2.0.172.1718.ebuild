# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/-bin}"
MY_P="${MY_PN}-${PV}"

inherit java-pkg-2

DESCRIPTION="Oracle SQLcl is the new SQL*Plus"
HOMEPAGE="https://www.oracle.com/database/technologies/appdev/sqlcl.html"
SRC_URI="https://download.oracle.com/otn_software/java/sqldeveloper/${MY_P}.zip"
RESTRICT="mirror"

LICENSE="OTN"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"
RDEPEND="dev-db/oracle-instantclient
	dev-java/java-config:2
	>=virtual/jre-11"

S="${WORKDIR}"

src_install() {
	java-pkg_dojar sqlcl/lib/*.jar sqlcl/lib/ext/*.jar

	java-pkg_dolauncher "${MY_PN}" \
		--main oracle.dbtools.raptor.scriptrunner.cmdline.SqlCli \
		--java_args '-client -Xss30M'
}
