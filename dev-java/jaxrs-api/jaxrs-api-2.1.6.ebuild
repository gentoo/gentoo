# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom jaxrs-api/pom.xml --download-uri https://github.com/jakartaee/rest/archive/2.1.6.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jaxrs-api-2.1.6.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="jakarta.ws.rs:jakarta.ws.rs-api:2.1.6"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta RESTful Web Services API"
HOMEPAGE="https://github.com/jakartaee/rest"
SRC_URI="https://github.com/jakartaee/rest/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-2.0 GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"

# Compile dependencies
# POM: ${PN}/pom.xml
# jakarta.activation:jakarta.activation-api:1.2.1 -> >=dev-java/jakarta-activation-api-1.2.2:1
# jakarta.xml.bind:jakarta.xml.bind-api:2.3.2 -> >=dev-java/jaxb-api-2.3.3:2
# POM: ${PN}/pom.xml
# test? junit:junit:4.11 -> >=dev-java/junit-4.13.2:4
# test? org.glassfish.jaxb:jaxb-runtime:2.3.2 -> !!!groupId-not-found!!!
# test? org.mockito:mockito-core:2.22.0 -> >=dev-java/mockito-4.4.0:4

DEPEND="
	>=virtual/jdk-11:*
	dev-java/jakarta-activation-api:1
	dev-java/jaxb-api:2
	test? (
		dev-java/jaxb-runtime:4
		dev-java/mockito:4
	)
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( ../{CONTRIBUTING,NOTICE,README}.md )

S="${WORKDIR}/rest-${PV}/${PN}"

JAVA_CLASSPATH_EXTRA="jakarta-activation-api-1,jaxb-api-2"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="jaxb-runtime-4,junit-4,mockito-4"
JAVA_TEST_SRC_DIR="src/test/java"

# "mvn test" -> Tests run: 34, Failures: 0, Errors: 0, Skipped: 3
# 1) testSerializationOfJaxbLink(javax.ws.rs.core.JaxbLinkTest)
# javax.xml.bind.JAXBException: Implementation of JAXB-API has not been found on module path or classpath.
JAVA_TEST_EXCLUDES=(
	javax.ws.rs.core.JaxbLinkTest
)
