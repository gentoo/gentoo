# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.joda:joda-convert:2.2.4"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Library to convert Objects to and from String"
HOMEPAGE="https://www.joda.org/joda-convert/"
SRC_URI="https://github.com/JodaOrg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

DEPEND="
	>=virtual/jdk-11:*
	test? (
		dev-java/guava:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {NOTICE,RELEASE-NOTES}.txt README.md )

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="guava,junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

JAVA_TEST_EXCLUDES=(
	# Upstream: Tests run: 186, Failures: 0, Errors: 0, Skipped: 0
	# All following: No runnable methods
	org.joda.convert.test1.Test1Class
	org.joda.convert.test1.Test1Interface
	org.joda.convert.test2.Test2Class
	org.joda.convert.test2.Test2Factory
	org.joda.convert.test2.Test2Interface
	org.joda.convert.test3.Test3Class
	org.joda.convert.test3.Test3Factory
	org.joda.convert.test3.Test3Interface
	org.joda.convert.test3.Test3SuperClass
	org.joda.convert.test4.Test4Class
	org.joda.convert.test4.Test4Factory
	org.joda.convert.test4.Test4Interface
	org.joda.convert.TestRenameHandlerBadInit
)
