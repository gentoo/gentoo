# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/bitstrings/junit-clptr/archive/refs/tags/1.2.2.tar.gz --slot 0 --keywords "~amd64 ~x86" --ebuild junit-clptr-1.2.2.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.bitstrings.test:junit-clptr:1.2.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="ClassLoader per Test runner for JUnit 4.12+ based on myfaces-test \"TestPerClassLoaderRunner\"."
HOMEPAGE="http://nexus.sonatype.org/oss-repository-hosting.html/junit-clptr"
SRC_URI="https://github.com/bitstrings/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}-sources.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

# Common dependencies
# POM: pom.xml
# junit:junit:4.12 -> >=dev-java/junit-4.13.2:4

CDEPEND="
	dev-java/junit:4
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}
"

S="${WORKDIR}/${P}"

JAVA_GENTOO_CLASSPATH="junit-4"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS=(
	"src/main/resources"
)
