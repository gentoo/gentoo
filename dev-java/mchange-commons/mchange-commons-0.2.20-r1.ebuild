# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
#	JAVA_TESTING_FRAMEWORKS=""
MAVEN_ID="com.mchange:mchange-commons-java:0.2.20"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="a library of arguably useful Java utilities."
HOMEPAGE="https://github.com/swaldman/mchange-commons-java"
SRC_URI="https://github.com/swaldman/${PN}-java/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/mchange-commons-java-${PV}"

LICENSE="EPL-1.0 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

CP_DEPEND="
	>=dev-java/log4j-api-2.25.2:0
	>=dev-java/log4j-12-api-2.25.2:0
	>=dev-java/log4j-core-2.25.2:0
	>=dev-java/slf4j-api-2.0.3:0
	>=dev-java/typesafe-config-1.4.5:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	!<app-forensics/sleuthkit-4.12.1-r3
	!<dev-java/c3p0-0.9.5.5-r3:0
	>=virtual/jre-1.8:*
"

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

#	# https://github.com/swaldman/mchange-commons-java/blob/master/build.sbt#L29-L31
#	JAVA_TEST_GENTOO_CLASSPATH=""
#	JAVA_TEST_SRC_DIR="src/test/java"
#	JAVA_TEST_RESOURCE_DIRS="src/test/resources"
