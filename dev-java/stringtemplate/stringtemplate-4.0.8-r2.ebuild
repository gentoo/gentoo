# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/antlr/stringtemplate4/archive/refs/tags/4.0.8.tar.gz --slot 4 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild stringtemplate-4.0.8-r2.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.antlr:ST4:4.0.8"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java template engine"
HOMEPAGE="https://www.stringtemplate.org"
SRC_URI="https://github.com/antlr/${PN}4/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-1"
SLOT="4"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# Common dependencies
# POM: pom.xml
# org.antlr:antlr-runtime:3.5.2 -> >=dev-java/antlr-runtime-3.5.2:3.5

CDEPEND="
	dev-java/antlr-runtime:3.5
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}
"

DOCS=( {CHANGES,README,LICENSE,contributors}.txt )

S="${WORKDIR}/${PN}4-${PV}"

JAVA_GENTOO_CLASSPATH="antlr-runtime-3.5"
JAVA_SRC_DIR="src"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="test"
JAVA_TEST_RESOURCE_DIRS="test"
