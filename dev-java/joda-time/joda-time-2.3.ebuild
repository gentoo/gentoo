# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/joda-time/joda-time-2.3.ebuild,v 1.3 2015/03/23 09:34:04 monsieurp Exp $

EAPI="5"
JAVA_PKG_IUSE="doc examples source test"
JAVA_ANT_REWRITE_CLASSPATH="true"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A quality open-source replacement for the Java Date and Time classes"
HOMEPAGE="http://www.joda.org/joda-time/ https://github.com/JodaOrg/joda-time/"
SRC_URI="mirror://sourceforge/${PN}/${P}-dist.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"

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
