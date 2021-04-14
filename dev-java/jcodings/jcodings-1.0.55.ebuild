# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/jruby/jcodings/archive/refs/tags/jcodings-1.0.55.tar.gz --slot 1 --keywords "~amd64 ~x86" --ebuild jcodings-1.0.55.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jruby.jcodings:jcodings:1.0.55"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Byte based encoding support library for java"
HOMEPAGE="https://github.com/jruby/jcodings"
SRC_URI="https://github.com/jruby/${PN}/archive/refs/tags/${P}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=virtual/jdk-11:*
"

RDEPEND="
	>=virtual/jre-11:*
"

S="${WORKDIR}/${PN}-${P}"

JAVA_SRC_DIR="src"
JAVA_RESOURCE_DIRS="resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="test"
