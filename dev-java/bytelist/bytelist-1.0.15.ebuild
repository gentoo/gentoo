# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/jruby/bytelist/archive/refs/tags/bytelist-1.0.15.tar.gz --slot 0 --keywords "~amd64 ~x86" --ebuild bytelist-1.0.15.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jruby.extras:bytelist:1.0.15"
JAVA_TESTING_FRAMEWORKS="junit"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Byte array based container"
HOMEPAGE="https://github.com/jruby/bytelist"
SRC_URI="https://github.com/jruby/${PN}/archive/refs/tags/${P}.tar.gz -> ${P}-sources.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Common dependencies
# POM: pom.xml
# org.jruby.jcodings:jcodings:1.0.18 -> >=dev-java/jcodings-1.0.11:1

CDEPEND="
	>=dev-java/jcodings-1.0.11:1
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}
"

S="${WORKDIR}/${PN}-${P}"

JAVA_GENTOO_CLASSPATH="jcodings-1"
JAVA_SRC_DIR="src"

JAVA_TEST_GENTOO_CLASSPATH="junit"
JAVA_TEST_SRC_DIR="test"
