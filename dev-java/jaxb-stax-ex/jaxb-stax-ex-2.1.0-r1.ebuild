# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/eclipse-ee4j/jaxb-stax-ex/archive/2.1.0.tar.gz --slot 0 --keywords "~amd64 ~ppc64 ~x86" --ebuild jaxb-stax-ex-2.1.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jvnet.staxex:stax-ex:2.1.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Extensions to JSR-173 StAX API."
HOMEPAGE="https://projects.eclipse.org/projects/ee4j/stax-ex"
SRC_URI="https://github.com/eclipse-ee4j/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="
	dev-java/jakarta-activation-api:2
	dev-java/jaxb-api:4
	>=virtual/jdk-11:*
"

RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/${P}"

JAVA_CLASSPATH_EXTRA="jakarta-activation-api-2,jaxb-api-4"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
