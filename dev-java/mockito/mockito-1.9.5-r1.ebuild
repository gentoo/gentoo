# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A mocking framework for Java"
HOMEPAGE="https://github.com/mockito/mockito"
SRC_URI="https://${PN}.googlecode.com/files/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

IUSE=""

CDEPEND="dev-java/junit:4
	dev-java/objenesis:0
	dev-java/hamcrest-core:0
	dev-java/ant-core:0"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${CDEPEND}"

S="${WORKDIR}"

JAVA_SRC_DIR="src"
JAVA_GENTOO_CLASSPATH="junit-4,objenesis,hamcrest-core,ant-core"

src_unpack() {
	unpack ${A}
	unzip "${S}"/sources/${PN}-core-${PV}-sources.jar -d src/ || die
}

java_prepare() {
	find "${S}" -name "*.jar" -delete || die
}
