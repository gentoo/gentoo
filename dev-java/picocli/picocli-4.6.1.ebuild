# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/remkop/picocli/archive/refs/tags/v4.6.1.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x68" --ebuild picocli-4.6.1.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="info.picocli:picocli:4.0.0-alpha-3"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java command line parser with both an annotations API and a programmatic API"
HOMEPAGE="http://picocli.info"
SRC_URI="https://github.com/remkop/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}-sources.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 x86"

# package org.junit.contrib.java.lang.system does not exist
RESTRICT="test"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*
	test? ( dev-java/jansi:0 )"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

DOCS=( LICENSE README.md RELEASE-NOTES.md )

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main"

JAVA_TEST_GENTOO_CLASSPATH="jansi,junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_install() {
	default
	java-pkg-simple_src_install
}
