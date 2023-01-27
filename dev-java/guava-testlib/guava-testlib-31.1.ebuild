# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom guava-testlib/pom.xml --download-uri https://github.com/google/guava/archive/v31.1.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild guava-testlib-31.1.ebuild

EAPI=8

# No tests because "error: package com.google.common.truth does not exist"
JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.google.guava:guava-testlib:31.1-jre"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A set of java classes to assist the tests for Guava itself"
HOMEPAGE="https://github.com/google/guava"
SRC_URI="https://github.com/google/guava/archive/v${PV}.tar.gz -> guava-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Common dependencies
# POM: ${PN}/pom.xml
# com.google.code.findbugs:jsr305:3.0.2 -> >=dev-java/jsr305-3.0.2:0
# com.google.errorprone:error_prone_annotations:2.11.0 -> >=dev-java/error-prone-annotations-2.16:0
# com.google.guava:guava:31.1-jre -> >=dev-java/guava-31.1:0
# com.google.j2objc:j2objc-annotations:1.3 -> >=dev-java/j2objc-annotations-2.8:0
# junit:junit:4.13.2 -> >=dev-java/junit-4.13.2:4
# org.checkerframework:checker-qual:3.12.0 -> >=dev-java/checker-framework-qual-3.14.0:0

CP_DEPEND="
	dev-java/checker-framework-qual:0
	dev-java/error-prone-annotations:0
	~dev-java/guava-${PV}:0
	dev-java/j2objc-annotations:0
	dev-java/jsr305:0
	dev-java/junit:4
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

S="${WORKDIR}/guava-${PV}"

JAVA_SRC_DIR="${PN}/src"
