# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom runtime/pom.xml --download-uri https://github.com/eclipse-ee4j/jaxb-istack-commons/archive/4.1.1.tar.gz --slot 0 --keywords "~amd64 ~ppc64 ~x86" --ebuild jaxb-istack-commons-runtime-4.1.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.sun.istack:istack-commons-runtime:4.1.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="istack common utility code"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j/istack-commons/"
SRC_URI="https://github.com/eclipse-ee4j/jaxb-istack-commons/archive/${PV}.tar.gz -> jaxb-istack-commons-${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

# Compile dependencies
# POM: runtime/pom.xml
# jakarta.activation:jakarta.activation-api:2.1.0 -> >=dev-java/jakarta-activation-api-2.1.0:2
# POM: runtime/pom.xml
# test? junit:junit:4.13.2 -> >=dev-java/junit-4.13.2:4

DEPEND="
	>=virtual/jdk-1.8:*
	dev-java/jakarta-activation-api:2
"

RDEPEND="
	>=virtual/jre-1.8:*
"

DOCS=( ../{CONTRIBUTING,NOTICE,README}.md )

S="${WORKDIR}/jaxb-istack-commons-${PV}/istack-commons"

JAVA_CLASSPATH_EXTRA="jakarta-activation-api-2"
JAVA_SRC_DIR="runtime/src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="runtime/src/test/java"

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
