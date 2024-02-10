# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="de.unkrig.commons:commons-junit4:1.2.17"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Assertions etc. for those who write tests with JUNIT 4"
HOMEPAGE="https://unkrig.de/w/Commons.unkrig.de"
SRC_URI="https://github.com/aunkrig/commons/archive/V${PV}.tar.gz -> unkrig-commons${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CP_DEPEND="
	~dev-java/commons-nullanalysis-${PV}:0
	dev-java/junit:4
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

S="${WORKDIR}/commons-${PV}/commons-junit4"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
