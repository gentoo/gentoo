# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="cz.startnet:apgdiff:2.7.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A simple PostgreSQL diff tool that is useful for schema upgrades"
HOMEPAGE="https://github.com/fordfrog/apgdiff https://www.apgdiff.com/"
SRC_URI="https://github.com/fordfrog/${PN}/archive/release_${PV}.tar.gz -> ${P}-sources.tar.gz"
S="${WORKDIR}/${PN}-release_${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/hamcrest-core:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

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
