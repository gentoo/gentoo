# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/eclipse-ee4j/jaxb-fi/archive/2.1.0.tar.gz --slot 0 --keywords "~amd64 ~ppc64 ~x86" --ebuild fastinfoset-2.1.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.sun.xml.fastinfoset:FastInfoset:2.1.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Open Source implementation of the Fast Infoset Standard for Binary XML"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.jaxb-impl/FastInfoset"
SRC_URI="https://github.com/eclipse-ee4j/jaxb-fi/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

DOCS=( ../{CONTRIBUTING,NOTICE,README}.md )
HTML_DOCS=( docs/{index,ReleaseNotes}.html )

S="${WORKDIR}/jaxb-fi-${PV}/${PN}"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
