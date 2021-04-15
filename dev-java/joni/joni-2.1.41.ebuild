# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/jruby/joni/archive/refs/tags/joni-2.1.41.tar.gz --slot 2.1 --keywords "~amd64 ~ppc64 ~x86" --ebuild joni-2.1.41.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jruby.joni:joni:2.1.41"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java port of the Oniguruma regular expression engine"
HOMEPAGE="https://github.com/jruby/joni"
SRC_URI="https://github.com/jruby/${PN}/archive/refs/tags/${P}.tar.gz"

LICENSE="MIT"
SLOT="2.1"
KEYWORDS="~amd64 ~ppc64 ~x86"

# Common dependencies
# POM: pom.xml
# org.jruby.jcodings:jcodings:1.0.55 -> >=dev-java/jcodings-1.0.55:1

CDEPEND="
	dev-java/jcodings:1
"

DEPEND="
	>=virtual/jdk-11:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-11:*
	${CDEPEND}"

S="${WORKDIR}/${PN}-${P}"

JAVA_GENTOO_CLASSPATH="jcodings-1"
JAVA_SRC_DIR="src"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="test"
