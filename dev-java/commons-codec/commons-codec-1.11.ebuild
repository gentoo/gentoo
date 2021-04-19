# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"
MAVEN_ID="commons-codec:commons-codec:1.11"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Implementations of common encoders and decoders in Java"
HOMEPAGE="https://commons.apache.org/codec"
SRC_URI="mirror://apache/commons/codec/source/${P}-src.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	test? (
		dev-java/ant-junit:0
		dev-java/junit:4
	)"

S="${WORKDIR}/${P}-src"

JAVA_ANT_ENCODING="ISO-8859-1"
EANT_TEST_GENTOO_CLASSPATH="junit-4"

JAVA_ANT_REWRITE_CLASSPATH="yes"

RESTRICT="test"

DOCS=( RELEASE-NOTES.txt NOTICE.txt )

src_prepare() {
	cp "${FILESDIR}/${P}-build.xml" "${S}/build.xml" || die
	default
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar "target/${P}.jar"

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
