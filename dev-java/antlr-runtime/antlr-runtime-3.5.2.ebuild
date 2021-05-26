# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/antlr/antlr3/archive/5c2a916a10139cdb5c7c8851ee592ed9c3b3d4ff.tar.gz --slot 3.5 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild antlr3-runtime-3.5.2-r2.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.antlr:antlr-runtime:3.5.3"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

MY_COMMIT="5c2a916a10139cdb5c7c8851ee592ed9c3b3d4ff"
DESCRIPTION="A parser generator for many languages"
HOMEPAGE="https://www.antlr3.org/ https://www.antlr.org"
SRC_URI="https://github.com/antlr/antlr3/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-1"
SLOT="3.5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

# Common dependencies
# POM: pom.xml
# org.antlr:stringtemplate:3.2.1 -> >=dev-java/stringtemplate-3.2.1:0

CDEPEND="
	dev-java/stringtemplate:0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}
"

DOCS=( ../../README.txt )

S="${WORKDIR}/antlr3-${MY_COMMIT}/runtime/Java"

JAVA_GENTOO_CLASSPATH="stringtemplate"
JAVA_SRC_DIR="src/main/java"

# JAVA_TEST_GENTOO_CLASSPATH="!!!groupId-not-found!!!"
JAVA_TEST_SRC_DIR="src/test/java"
