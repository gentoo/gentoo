# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java API for working with archive files"
HOMEPAGE="https://commons.apache.org/proper/commons-compress/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="dev-java/xz-java:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	test? (
		dev-java/junit:4
		dev-java/ant-junit:0
		dev-java/hamcrest-core:1.3
	)"

S="${WORKDIR}/${P}-src"

JAVA_ANT_BSFIX_EXTRA_ARGS="--maven-cleaning"
EANT_GENTOO_CLASSPATH="xz-java"
EANT_BUILD_TARGET="compile package"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4,hamcrest-core-1.3"

# Dubious tests.
JAVA_RM_FILES=(
	src/test/java/org/apache/commons/compress/archivers/zip/X5455_ExtendedTimestampTest.java
)

java_prepare() {
	cp "${FILESDIR}"/build.xml . || die "Failed to copy build.xml"

	# osgi stuff mvn ant:ant doesn't handle
	mkdir -p target/osgi || die "Failed to create target dir"
	cp "${FILESDIR}"/MANIFEST.MF target/osgi/ || die "Failed to copy manifest"

	if ! use test; then
		find -name "*.jar" -delete || die "Failed to remove test resources"
	fi
}

src_test() {
	EANT_TEST_TARGET="compile-tests test" \
		java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar "target/${PN}-1.1.jar"
	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
