# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.mockito:mockito-core:1.9.5"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A mocking framework for Java"
HOMEPAGE="https://github.com/mockito/mockito"
SRC_URI="https://${PN}.googlecode.com/files/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 x86"

CDEPEND="
	dev-java/ant-core:0
	dev-java/hamcrest-core:0
	dev-java/junit:4
	dev-java/objenesis:0
"
RDEPEND="${CDEPEND}
	virtual/jre:1.8"
DEPEND="${CDEPEND}
	virtual/jdk:1.8"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"

JAVA_SRC_DIR="src"
JAVA_GENTOO_CLASSPATH="junit-4,objenesis,hamcrest-core,ant-core"

src_unpack() {
	unpack ${A}
	unzip "${S}"/sources/${PN}-core-${PV}-sources.jar -d src/ || die
}

src_prepare() {
	default
	find "${S}" -name "*.jar" -delete || die
}
