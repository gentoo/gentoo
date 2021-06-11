# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_P="apache-mina-${PV}"

DESCRIPTION="Apache MINA Project"
HOMEPAGE="https://mina.apache.org/"
SRC_URI="mirror://apache/mina/mina/${PV}/${MY_P}-src.tar.bz2 -> ${P}.tar.bz2"
KEYWORDS="amd64 ppc64 x86"
LICENSE="Apache-2.0"
SLOT="0"

CDEPEND="dev-java/slf4j-api:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

S="${WORKDIR}/${MY_P}"

JAVA_GENTOO_CLASSPATH="slf4j-api"

JAVA_SRC_DIR="my_src"

src_prepare() {
	default
	mkdir my_src || die
	mv src/mina-core/src/main/java/org my_src || die
}
