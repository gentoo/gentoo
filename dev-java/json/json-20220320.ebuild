# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://codeload.github.com/stleary/JSON-java/tar.gz/20220320 --slot 0 --keywords "~amd64 ~x86" --ebuild json-20220320.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.json:json:20220320"
# We don't have com.jayway.jsonpath:json-path
# JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A reference implementation of a JSON package in Java"
HOMEPAGE="https://github.com/stleary/JSON-java"
SRC_URI="https://codeload.github.com/stleary/JSON-java/tar.gz/${PV} -> ${P}.tar.gz"

LICENSE="JSON"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Compile dependencies
# POM: pom.xml
# test? com.jayway.jsonpath:json-path:2.1.0 -> !!!groupId-not-found!!!
# test? junit:junit:4.13.1 -> >=dev-java/junit-4.13.2:4
# test? org.mockito:mockito-core:1.9.5 -> >=dev-java/mockito-1.9.5:0

DEPEND="
	>=virtual/jdk-1.8:*"
#	test? (
#		!!!groupId-not-found!!!
#		>=dev-java/mockito-1.9.5:0
#	)
#"

RDEPEND="
	>=virtual/jre-1.8:*
"

DOCS=( {README,SECURITY}.md )

S="${WORKDIR}/JSON-java-${PV}"

JAVA_SRC_DIR="src/main/java"

#	JAVA_TEST_GENTOO_CLASSPATH="!!!groupId-not-found!!!,junit-4,mockito"
#	JAVA_TEST_SRC_DIR="src/test/java"
#	JAVA_TEST_RESOURCE_DIRS=(
#		"src/test/resources"
#	)

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
