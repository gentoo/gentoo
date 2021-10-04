# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/fordfrog/apgdiff/archive/refs/tags/release_2.7.0.tar.gz --slot 0 --keywords "~amd64 ~x86" --ebuild apgdiff-2.7.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="cz.startnet:apgdiff:2.7.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A simple PostgreSQL diff tool that is useful for schema upgrades"
HOMEPAGE="https://github.com/fordfrog/apgdiff https://www.apgdiff.com/"
SRC_URI="https://github.com/fordfrog/${PN}/archive/refs/tags/release_${PV}.tar.gz -> ${P}-sources.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Compile dependencies
# POM: pom.xml
# test? junit:junit:4.13.1 -> >=dev-java/junit-4.13.2:4
# test? org.hamcrest:hamcrest-all:1.3 -> !!!artifactId-not-found!!!

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
	test? (
		dev-java/hamcrest-core:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

RESTRICT="!test? ( test )"

S="${WORKDIR}/${PN}-release_${PV}"

JAVA_LAUNCHER_FILENAME="${PN}"

JAVA_SRC_DIR="src/main/java"
JAVA_MAIN_CLASS="cz.startnet.utils.pgdiff.Main"
JAVA_RESOURCE_DIRS=(
	"src/main/resources"
)

JAVA_TEST_GENTOO_CLASSPATH="hamcrest-core,junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS=(
	"src/test/resources"
)
