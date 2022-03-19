# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://codeload.github.com/teras/appenh/tar.gz/137b99422ad02953cf957e09b129a47b876d1e2a --slot 0 --keywords "~amd64" --ebuild appenh-0.5.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.panayotis:appenh:0.5.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

MY_COMMIT="137b99422ad02953cf957e09b129a47b876d1e2a"
DESCRIPTION="Cross-platform access of java application properties"
HOMEPAGE="https://github.com/teras/appenh"
SRC_URI="https://github.com/teras/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Common dependencies
# POM: pom.xml
# com.panayotis:loadlib:0.2.2 -> >=dev-java/loadlib-0.2.2:0

CP_DEPEND="
	dev-java/loadlib:0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

S="${WORKDIR}/${PN}-${MY_COMMIT}"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_EXCLUDES=(
	# org.junit.runners.model.InvalidTestClassError: Invalid test class 'com.panayotis.appenh.MainTest':
	#   1. No runnable methods
	com.panayotis.appenh.MainTest
)
