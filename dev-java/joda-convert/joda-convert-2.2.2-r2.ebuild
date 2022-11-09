# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/JodaOrg/joda-convert/archive/refs/tags/v2.2.2.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild joda-convert-2.2.2.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.joda:joda-convert:2.2.2"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Library to convert Objects to and from String"
HOMEPAGE="https://www.joda.org/joda-convert/"
SRC_URI="https://github.com/JodaOrg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Compile dependencies
# POM: pom.xml
# test? com.google.guava:guava:31.0.1-jre -> !!!suitable-mavenVersion-not-found!!!
# test? junit:junit:4.13.2 -> >=dev-java/junit-4.13.2:4

DEPEND="
	>=virtual/jdk-11:*
	test? (
		dev-java/guava:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

DOCS=( {NOTICE,RELEASE-NOTES}.txt README.md )

S="${WORKDIR}/${P}"

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
