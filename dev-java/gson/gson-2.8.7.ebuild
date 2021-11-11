# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom gson/pom.xml --download-uri https://github.com/google/gson/archive/gson-parent-2.8.7.tar.gz --slot 2.6 --keywords "~amd64 ~ppc64 ~x86" --ebuild gson-2.8.7.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.code.gson:gson:2.8.7"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Gson JSON library"
HOMEPAGE="https://github.com/google/gson/gson"
SRC_URI="https://github.com/google/${PN}/archive/${PN}-parent-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2.6"
KEYWORDS="amd64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/${PN}-${PN}-parent-${PV}/${PN}"

JAVA_SRC_DIR=(
	"src/main/java"
	"src/main/java-templates"
)

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default
	sed -i "s/\${project.version}/${PV}/g" src/main/java-templates/com/google/gson/internal/GsonBuildConfig.java || die "Failed to set version"
}
