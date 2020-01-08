# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
JAVA_PKG_IUSE="doc examples source test"
JAVA_ANT_REWRITE_CLASSPATH="true"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A quality open-source replacement for the Java Date and Time classes"
HOMEPAGE="http://www.joda.org/joda-time/ https://github.com/JodaOrg/joda-time/"
SRC_URI="https://github.com/JodaOrg/${PN}/releases/download/v${PV}/${P}-dist.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"

RESTRICT="test"

DEPEND=">=virtual/jdk-1.5
	dev-java/joda-convert:0
	test? (
		dev-java/junit:0
		dev-java/ant-junit:0
	)"
RDEPEND=">=virtual/jre-1.5"

java_prepare() {
	rm -v *.jar || die "Failed to remove bundled jars."
	cp "${FILESDIR}"/${P}-build.xml "${S}"/build.xml || die "Failed to copy build file."

	mkdir -p "${S}"/target/classes || die "Failed to create target classes directory."
	cp -Rv "${S}"/src/tz-data/* "${S}"/target/classes/ || die "Failed to copy timezone data."

	mkdir -p "${S}"/target/classes/org/joda/time/format || die "Failed to create target classes subdirectory."
	cp -Rv "${S}"/src/main/java/org/joda/time/format/*properties "${S}"/target/classes/org/joda/time/format/ || die "Failed to copy message bundles."
}

src_compile() {
	EANT_EXTRA_ARGS="-Dgentoo.classpath=$(java-pkg_getjar --build-only joda-convert joda-convert.jar)"

	java-pkg-2_src_compile
}

src_test() {
	EANT_EXTRA_ARGS="-Dgentoo.classpath=$(java-pkg_getjar --build-only joda-convert joda-convert.jar):$(java-pkg_getjar --build-only junit junit.jar)"

	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${P}.jar

	dodoc NOTICE.txt RELEASE-NOTES.txt

	use doc && java-pkg_dojavadoc target/site/apidocs
	use examples && java-pkg_doexamples src/example
	use source && java-pkg_dosrc src/main/java/*
}
