# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://apache/felix/org.apache.felix.utils-1.11.8-source-release.tar.gz --slot 0 --keywords "~amd64" --ebuild felix-utils-1.11.8.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.felix:org.apache.felix.utils:1.11.8"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Utility classes for OSGi"
HOMEPAGE="https://felix.apache.org/documentation/index.html"
SRC_URI="mirror://apache/felix/org.apache.felix.utils-${PV}-source-release.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm"

# Compile dependencies
# POM: pom.xml
# org.osgi:osgi.cmpn:5.0.0 -> >=dev-java/osgi-cmpn-8.0.0:8
# org.osgi:osgi.core:5.0.0 -> >=dev-java/osgi-core-8.0.0:0
# POM: pom.xml
# test? junit:junit:4.12 -> >=dev-java/junit-4.13.2:4
# test? org.mockito:mockito-core:2.18.3 -> >=dev-java/mockito-4.7.0:4

DEPEND="
	>=virtual/jdk-1.8:*
	dev-java/osgi-cmpn:8
	dev-java/osgi-core:0
	test? (
		dev-java/mockito:4
	)
"

RDEPEND=">=virtual/jre-1.8:*"

PATCHES=(
	"${FILESDIR}/felix-utils-1.11.8-Port-to-osgi-cmpn.patch"
)

DOCS=( DEPENDENCIES NOTICE doc/changelog.txt )

S="${WORKDIR}/org.apache.felix.utils-${PV}"

JAVA_CLASSPATH_EXTRA="osgi-cmpn-8,osgi-core"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,mockito-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_prepare() {
	default # https://bugs.gentoo.org/780585
}
