# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom objenesis-3.2/main/pom.xml --download-uri https://github.com/easymock/objenesis/archive/refs/tags/3.2.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild objenesis-3.2.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.objenesis:objenesis:3.2"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A library for instantiating Java objects"
HOMEPAGE="http://objenesis.org/objenesis"
SRC_URI="https://github.com/easymock/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 x86"

# Compile dependencies
# POM: ${P}/main/pom.xml
# test? junit:junit:4.13.2 -> >=dev-java/junit-4.13.2:4
# test? org.objenesis:objenesis-test:3.2 -> >=dev-java/objenesis-test-3.2:0

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/objenesis-test-3.2:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}"

JAVA_SRC_DIR="${P}/main/src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,objenesis-test"
JAVA_TEST_SRC_DIR="${P}/main/src/test/java"
