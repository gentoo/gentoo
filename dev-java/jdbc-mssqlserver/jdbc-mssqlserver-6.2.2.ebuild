# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 versionator

DESCRIPTION="JDBC driver for Microsoft SQL Server"
HOMEPAGE="https://github.com/Microsoft/mssql-jdbc"
SRC_URI="https://github.com/Microsoft/mssql-jdbc/releases/download/v${PV}/mssql-jdbc-${PV}.jre8.jar"

KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="4.2"

DEPEND=""
RDEPEND=">=virtual/jre-1.8"

S="${WORKDIR}"

src_unpack() {
	:
}

src_install() {
	java-pkg_newjar "${DISTDIR}/${A}"
}
