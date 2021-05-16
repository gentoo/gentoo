# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/-bin}"
MY_P="${MY_PN}-${PV}"

inherit java-pkg-2

DESCRIPTION="Oracle SQLcl is the new SQL*Plus"
HOMEPAGE="https://www.oracle.com/database/technologies/appdev/sqlcl.html"
SRC_URI="${MY_P}.zip"
RESTRICT="bindist fetch mirror"

LICENSE="OTN"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"
RDEPEND="dev-db/oracle-instantclient
	dev-java/java-config:2
	>=virtual/jre-1.8"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please go to"
	einfo
	einfo "	${HOMEPAGE}"
	einfo
	einfo "and download"
	einfo
	einfo "	Command Line - SQLcl"
	einfo "		${SRC_URI}"
	einfo
	einfo "which must be placed in DISTDIR directory."
}

src_install() {
	java-pkg_dojar sqlcl/lib/*.jar sqlcl/lib/ext/*.jar

	java-pkg_dolauncher "${MY_PN}" \
		--main oracle.dbtools.raptor.scriptrunner.cmdline.SqlCli \
		--java_args '-client -Xss30M'
}
