# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/apache/commons-collections/archive/refs/tags/collections-3.3.tar.gz --slot 0 --keywords "~amd64 ~ppc64 ~x86" --ebuild commons-collections-3.3.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-collections:commons-collections:3.3"
JAVA_TESTING_FRAMEWORKS="junit"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Types that extend and augment the Java Collections Framework."
HOMEPAGE="http://commons.apache.org/collections/"
SRC_URI="https://github.com/apache/${PN}/archive/refs/tags/collections-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/${PN}-collections-${PV}"

JAVA_SRC_DIR="src/java"
JAVA_RESOURCE_DIRS=(
	""
)

JAVA_TEST_GENTOO_CLASSPATH="junit"
JAVA_TEST_SRC_DIR="src/test"

src_prepare() {
	default
	sed -i \
		-e '/public Object remove/s/remove(/removeMapping(/' \
		src/java/org/apache/commons/collections/{MultiMap,MultiHashMap,map/MultiValueMap}.java || die
	sed -i \
		-e '/public Object remove/s/remove(/removeMultiKey(/' \
		src/java/org/apache/commons/collections/map/MultiKeyMap.java || die
}
