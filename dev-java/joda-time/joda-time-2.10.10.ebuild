# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom joda-time-2.10.10/pom.xml --download-uri https://github.com/JodaOrg/joda-time/archive/refs/tags/v2.10.10.tar.gz --slot 0 --keywords "~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris" --ebuild joda-time-2.10.10.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="joda-time:joda-time:2.10.10"
JAVA_TESTING_FRAMEWORKS="junit"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Date and time library to replace JDK date handling"
HOMEPAGE="https://www.joda.org/joda-time/"
SRC_URI="https://github.com/JodaOrg/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}-sources.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

# Common dependencies
# POM: ${P}/pom.xml
# org.joda:joda-convert:1.9.2 -> >=dev-java/joda-convert-2.2.1:0

CDEPEND="
	dev-java/joda-convert:0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="joda-convert"
JAVA_SRC_DIR="${P}/src/main/java"
JAVA_RESOURCE_DIRS=(
	"${P}/src/main/java"
)

JAVA_TEST_GENTOO_CLASSPATH="junit"
JAVA_TEST_SRC_DIR="${P}/src/test/java"
JAVA_TEST_RESOURCE_DIRS=(
	"${P}/src/test/resources"
)
