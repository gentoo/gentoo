# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.github.javaparser:javaparser-core:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java 1-21 Parser and Abstract Syntax Tree for Java"
HOMEPAGE="https://javaparser.org/"
SRC_URI="https://github.com/javaparser/javaparser/archive/${P/core/parent}.tar.gz -> javaparser-${PV}.tar.gz"
S="${WORKDIR}/javaparser-${P/core/parent}"

LICENSE="Apache-2.0 LGPL-3"
# dev-java/bnd-7.1.0 seems not to like this version.
# biz.aQute.bnd.reporter/src/biz/aQute/bnd/reporter/codesnippet/JavaSnippetReader.java:20: error: cannot find symbol
# import com.github.javaparser.printer.PrettyPrinterConfiguration;
#                                     ^
#   symbol:   class PrettyPrinterConfiguration
#   location: package com.github.javaparser.printer
SLOT="0"
KEYWORDS="amd64 ~arm64"

JAVACC_SLOT="7.0.13"
BDEPEND="dev-java/javacc:${JAVACC_SLOT}"

# Does not compile with >=jdk:21 (not even with 'mvn clean compile'):
# javaparser-core/src/main/java/com/github/javaparser/ast/NodeList.java:243:
# error: getLast() in NodeList cannot implement getLast() in List
#     public Optional<N> getLast() {
#                        ^
#   return type Optional<N> is not compatible with N
#   where N,E are type-variables:
#     N extends Node declared in class NodeList
#     E extends Object declared in interface List
DEPEND="<virtual/jdk-21:*"
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
