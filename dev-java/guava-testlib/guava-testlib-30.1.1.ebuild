# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom guava-testlib --download-uri https://codeload.github.com/google/guava/tar.gz/refs/tags/v30.1.1 --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild guava-testlib-30.1.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.guava:guava-testlib:30.1.1-jre"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A set of java classes to assist the tests for Guava itself"
HOMEPAGE="https://github.com/google/guava"
SRC_URI="https://github.com/google/guava/archive/v${PV}.tar.gz -> guava-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"

# error: package com.google.common.truth does not exist
RESRTICT="test"

# Common dependencies
# POM: ${PN}
# com.google.code.findbugs:jsr305:3.0.2 -> !!!groupId-not-found!!!
# com.google.errorprone:error_prone_annotations:2.5.1 -> >=dev-java/error-prone-annotations-2.7.1:0
# com.google.guava:guava:30.1.1-jre -> >=dev-java/guava-30.1.1:0
# com.google.j2objc:j2objc-annotations:1.3 -> !!!groupId-not-found!!!
# junit:junit:4.13.2 -> >=dev-java/junit-4.13.2:4
# org.checkerframework:checker-qual:3.8.0 -> >=dev-java/checker-framework-qual-3.14.0:0

CP_DEPEND="
	dev-java/checker-framework-qual:0
	dev-java/error-prone-annotations:0
	~dev-java/guava-30.1.1:0
	dev-java/jsr305:0
	dev-java/junit:4
	dev-java/j2objc-annotations:0
"

# Compile dependencies
# POM: ${PN}
# test? com.google.truth:truth:1.1 -> !!!groupId-not-found!!!

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}"
#	test? (
#		!!!groupId-not-found!!!
#	)
#"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

S="${WORKDIR}/guava-${PV}"

JAVA_SRC_DIR=( "${PN}/src" )
#	JAVA_RESOURCE_DIRS="${PN}/src"

#	JAVA_TEST_GENTOO_CLASSPATH="!!!groupId-not-found!!!"
JAVA_TEST_SRC_DIR=( "${PN}/test" )
JAVA_TEST_RESOURCE_DIRS=( "${PN}/test" )
