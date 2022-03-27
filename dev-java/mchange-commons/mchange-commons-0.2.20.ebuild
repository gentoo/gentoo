# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom src/main/maven/pom.xml --download-uri https://github.com/swaldman/mchange-commons-java/archive/refs/tags/v0.2.20.tar.gz --slot 0 --keywords "~amd64 ~ppc64 ~x86" --ebuild mchange-commons-0.2.20.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.mchange:mchange-commons-java:0.2.20"
#	JAVA_TESTING_FRAMEWORKS=""

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="a library of arguably useful Java utilities."
HOMEPAGE="https://github.com/swaldman/mchange-commons-java"
SRC_URI="https://github.com/swaldman/${PN}-java/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"

CP_DEPEND="
	dev-java/log4j-api:2
	dev-java/log4j-12-api:2
	dev-java/log4j-core:2
	dev-java/slf4j-api:0
	dev-java/typesafe-config:0"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

S="${WORKDIR}/mchange-commons-java-${PV}"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

#	# https://github.com/swaldman/mchange-commons-java/blob/master/build.sbt#L29-L31
#	JAVA_TEST_GENTOO_CLASSPATH=""
#	JAVA_TEST_SRC_DIR="src/test/java"
#	JAVA_TEST_RESOURCE_DIRS="src/test/resources"
