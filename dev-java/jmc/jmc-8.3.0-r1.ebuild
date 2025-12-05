# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_PROVIDES="
	org.openjdk.jmc:common:${PV}
	org.openjdk.jmc:flightrecorder:${PV}
"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JDK Mission Control"
HOMEPAGE="https://openjdk.org/projects/jmc/"
SRC_URI="https://github.com/openjdk/jmc/archive/${PV}-ga.tar.gz -> ${P}.ga.tar.gz"
S="${WORKDIR}/${P}-ga"

LICENSE="UPL-1.0"
SLOT="8.3.0"
KEYWORDS="amd64"

DEPEND="
	dev-java/lz4-java:0
	dev-java/owasp-java-encoder:0
	>=virtual/jdk-1.8:*
"
RDEPEND=">=virtual/jre-1.8:*"

src_compile() {
	einfo "Compiling jmc-common.jar"
	JAVA_AUTOMATIC_MODULE_NAME="org.openjdk.jmc.common"
	JAVA_CLASSPATH_EXTRA="
		lz4-java
		owasp-java-encoder
	"
	JAVA_JAR_FILENAME="jmc-common.jar"
	JAVA_RESOURCE_DIRS="core/org.openjdk.jmc.common/src/main/resources"
	JAVA_SRC_DIR="core/org.openjdk.jmc.common/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":jmc-common.jar"
	rm -r target || die

	einfo "Compiling jmc-flightrecorder.jar"
	JAVA_AUTOMATIC_MODULE_NAME="org.openjdk.jmc.flightrecorder"
	JAVA_JAR_FILENAME="jmc-flightrecorder.jar"
	JAVA_RESOURCE_DIRS="core/org.openjdk.jmc.flightrecorder/src/main/resources"
	JAVA_SRC_DIR="core/org.openjdk.jmc.flightrecorder/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":jmc-flightrecorder.jar"
	rm -r target || die

	if use doc; then
		JAVA_SRC_DIR=()
		JAVA_SRC_DIR=(
			"core/org.openjdk.jmc.common/src/main/java"
			"core/org.openjdk.jmc.flightrecorder/src/main/java"
		)
		JAVA_JAR_FILENAME="ignoreme.jar"
		java-pkg-simple_src_compile
	fi
}

src_install() {
	default
	java-pkg_dojar jmc-common.jar jmc-flightrecorder.jar
	if use doc; then
		java-pkg_dojavadoc target/api
	fi
	if use source; then
		java-pkg_dosrc "core/org.openjdk.jmc.common/src/main/java/*"
		java-pkg_dosrc "core/org.openjdk.jmc.flightrecorder/src/main/java/*"
	fi
}
