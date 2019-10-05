# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache MINA Project"
HOMEPAGE="https://mina.apache.org/"
SRC_URI="mirror://gentoo/${P}.jar"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

CDEPEND="dev-java/slf4j-api:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="slf4j-api"
