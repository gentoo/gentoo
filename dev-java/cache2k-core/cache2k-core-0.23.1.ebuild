# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.cache2k:cache2k-core:0.23.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="light weight and high performance Java caching library: core"
HOMEPAGE="https://cache2k.org"
SRC_URI="https://github.com/cache2k/cache2k/archive/v${PV}.tar.gz -> cache2k-${PV}.tar.gz"
S="${WORKDIR}/cache2k-${PV}/core"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""

CP_DEPEND="
	dev-java/cache2k-api:0
	dev-java/commons-logging:0
"
DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"
RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS=( "src/main/resources" )
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
