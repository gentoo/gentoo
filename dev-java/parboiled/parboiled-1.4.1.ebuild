# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_PROVIDES="
	org.parboiled:parboiled-core:${PV}
	org.parboiled:parboiled-java:${PV}
"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Elegant parsing in Java and Scala - lightweight, easy-to-use, powerful"
HOMEPAGE="https://github.com/sirthias/parboiled"
SRC_URI="https://github.com/sirthias/parboiled/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

CP_DEPEND="dev-java/asm:9"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-11:*"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

src_compile() {
	einfo "Compiling parboiled-core"
	JAVA_JAR_FILENAME="parboiled-core.jar"
	JAVA_SRC_DIR="parboiled-core/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":parboiled-core.jar"
	rm -r target || die

	einfo "Compiling parboiled-java"
	JAVA_JAR_FILENAME="parboiled-java.jar"
	JAVA_SRC_DIR="parboiled-java/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":parboiled-java.jar"
	rm -r target || die

	if use doc; then
		JAVA_SRC_DIR=(
			"parboiled-core/src/main/java"
			"parboiled-java/src/main/java"
		)
		JAVA_JAR_FILENAME="ignoreme.jar"
		java-pkg-simple_src_compile
	fi
}

src_install() {
	default

	java-pkg_dojar "parboiled-core.jar"
	java-pkg_dojar "parboiled-java.jar"

	if use doc; then
		java-pkg_dojavadoc target/api
	fi

	if use source; then
		java-pkg_dosrc "parboiled-core/src/main/java/*"
		java-pkg_dosrc "parboiled-java/src/main/java/*"
	fi
}
