# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.felix:org.apache.felix.utils:1.11.8"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Utility classes for OSGi"
HOMEPAGE="https://felix.apache.org/documentation/index.html"
SRC_URI="mirror://apache/felix/org.apache.${PN//-/.}-${PV}-source-release.tar.gz
	verify-sig? ( https://downloads.apache.org/felix/org.apache.${PN//-/.}-${PV}-source-release.tar.gz.asc )"
S="${WORKDIR}/org.apache.felix.utils-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

DEPEND="
	>=virtual/jdk-1.8:*
	dev-java/osgi-cmpn:8
	dev-java/osgi-core:0
	test? (
		dev-java/mockito:4
	)
"

RDEPEND=">=virtual/jre-1.8:*"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-felix )"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/felix.apache.org.asc"

PATCHES=(
	"${FILESDIR}/felix-utils-1.11.8-Port-to-osgi-cmpn.patch"
)

DOCS=( DEPENDENCIES NOTICE doc/changelog.txt )

JAVA_CLASSPATH_EXTRA="osgi-cmpn-8,osgi-core"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,mockito-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_prepare() {
	default # https://bugs.gentoo.org/780585
}
