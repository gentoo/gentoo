# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.sun.istack:istack-commons-runtime:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="istack common utility code"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j/istack-commons/"
SRC_URI="https://github.com/eclipse-ee4j/jaxb-istack-commons/archive/${PV}.tar.gz -> jaxb-istack-commons-${PV}.tar.gz"
S="${WORKDIR}/jaxb-istack-commons-${PV}/istack-commons"

LICENSE="EPL-1.0"
SLOT="3"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# fails if jdk-1.8:* # https://bugs.gentoo.org/857024
DEPEND="
	>=virtual/jdk-11:*
	dev-java/jakarta-activation-api:1
"

RDEPEND="
	>=virtual/jre-1.8:*
"

DOCS=( ../{CONTRIBUTING,NOTICE,README}.md )

JAVA_CLASSPATH_EXTRA="jakarta-activation-api-1"
JAVA_SRC_DIR="runtime/src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="runtime/src/test/java"
