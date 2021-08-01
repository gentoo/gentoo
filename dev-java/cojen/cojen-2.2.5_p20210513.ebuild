# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom Cojen-edd3dead03bfba334e82620a74092807b39b04e2/pom.xml --download-uri https://github.com/cojen/Cojen/archive/edd3dead03bfba334e82620a74092807b39b04e2.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild cojen-2.2.5_p20210513.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.cojen:cojen:2.2.5"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

MY_COMMIT="edd3dead03bfba334e82620a74092807b39b04e2"
DESCRIPTION="Dynamic Java bytecode generation and disassembly tools."
HOMEPAGE="https://github.com/cojen/Cojen/wiki"
SRC_URI="https://github.com/${PN}/Cojen/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

# All 10 test classes invalid, missing @Test
# 1) initializationError(org.cojen.test.ConvertTest)
# org.junit.runners.model.InvalidTestClassError: Invalid test class 'org.cojen.test.ConvertTest':
RESTRICT="test"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/Cojen-${MY_COMMIT}"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
