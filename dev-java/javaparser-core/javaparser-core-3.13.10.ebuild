# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.github.javaparser:javaparser-core:3.13.10"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java 1-17 Parser and Abstract Syntax Tree for Java"
HOMEPAGE="https://javaparser.org/"
SRC_URI="https://github.com/javaparser/javaparser/archive/v${PV}.tar.gz -> javaparser-${PV}.tar.gz"
S="${WORKDIR}/javaparser-${PV}"

LICENSE="Apache-2.0 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

JAVACC_SLOT="7.0.4"

BDEPEND="dev-java/javacc:7.0.4"
# Does not compile with Java 21
DEPEND="<=virtual/jdk-17:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( CONTRIBUTING.md changelog.md readme.md )

JAVA_AUTOMATIC_MODULE_NAME="com.github.javaparser.core"
JAVA_SRC_DIR=(
	"${PN}/src/main/java"
	"${PN}/src/main/java-templates"
	"${PN}/src/main/javacc-support"
)

src_prepare() {
	java-pkg-2_src_prepare

	mkdir -p "${PN}/src/main/java/com/github/javaparser"
	javacc-${JAVACC_SLOT} -GRAMMAR_ENCODING=UTF-8 \
		-JDK_VERSION=1.8 \
		-OUTPUT_DIRECTORY="${PN}/src/main/java/com/github/javaparser" \
		"javaparser-core/src/main/javacc/java.jj" \
		|| die "Code generation with java.jj failed"
}
