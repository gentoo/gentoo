# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_PROVIDES="
	net.minidev:accessors-smart:${PV}
	net.minidev:json-smart:${PV}
"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JSON Small and Fast Parser"
HOMEPAGE="https://urielch.github.io"
SRC_URI="https://github.com/netplex/json-smart-v2/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-v2-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64"
RESTRICT="test" #839681

DEPEND="
	dev-java/asm:0
	>=virtual/jdk-1.8:*
"

RDEPEND=">=virtual/jre-1.8:*"

JAVADOC_CLASSPATH="asm"
JAVADOC_SRC_DIRS=(
	accessors-smart/src/main/java
	json-smart/src/main/java
)

src_compile() {
	einfo "Compiling accessors-smart.jar"
	JAVA_CLASSPATH_EXTRA="asm"
	JAVA_JAR_FILENAME="accessors-smart.jar"
	JAVA_SRC_DIR="accessors-smart/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":accessors-smart.jar"
	rm -r target || die

	einfo "Compiling json-smart.jar"
	JAVA_JAR_FILENAME="json-smart.jar"
	JAVA_SRC_DIR="json-smart/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":json-smart.jar"
	rm -r target || die

	use doc && ejavadoc
}

src_install() {
	einstalldocs
	java-pkg_dojar "accessors-smart.jar"
	java-pkg_dojar "json-smart.jar"

	if use doc; then
		java-pkg_dojavadoc target/api
	fi

	if use source; then
		java-pkg_dosrc "accessors-smart/src/main/java/*"
		java-pkg_dosrc "json-smart/src/main/java/*"
	fi
}
