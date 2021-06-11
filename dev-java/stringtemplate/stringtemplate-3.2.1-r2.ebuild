# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/antlr/stringtemplate3/archive/68f2a42e8038f8e716e9666909ea485ee8aff45a.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild stringtemplate-3.2.1-r2.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.antlr:stringtemplate:3.2.2"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

MY_COMMIT="68f2a42e8038f8e716e9666909ea485ee8aff45a"
DESCRIPTION="A Java template engine"
HOMEPAGE="https://www.stringtemplate.org/"
SRC_URI="https://github.com/antlr/stringtemplate3/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-1"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# Common dependencies
# POM: pom.xml
# antlr:antlr:2.7.7 -> >=dev-java/antlr-2.7.7:0

CDEPEND="
	dev-java/antlr:0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}
"

DOCS=( {CHANGES,README}.txt )

S="${WORKDIR}/${PN}3-${MY_COMMIT}"

JAVA_GENTOO_CLASSPATH="antlr"
JAVA_SRC_DIR="src"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="test"
JAVA_TEST_RESOURCE_DIRS="test"

src_compile() {
	local G; for G in action template angle.bracket.template eval group interface; do # from build.xml
		antlr -o src/org/antlr/stringtemplate/language/{,${G}.g} || die
	done

	java-pkg-simple_src_compile
}
