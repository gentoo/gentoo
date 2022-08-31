# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/ronmamo/reflections/archive/0.9.12.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild reflections-0.9.12.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.reflections:reflections:0.9.12"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Reflections - a Java runtime metadata analysis"
HOMEPAGE="https://github.com/ronmamo/reflections"
SRC_URI="https://github.com/ronmamo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="WTFPL-2 BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Common dependencies
# POM: pom.xml
# com.google.code.gson:gson:2.8.6 -> >=dev-java/gson-2.8.8:2.6
# org.dom4j:dom4j:2.1.1 -> >=dev-java/dom4j-2.1.3:1
# org.javassist:javassist:3.26.0-GA -> !!!suitable-mavenVersion-not-found!!!
# org.slf4j:slf4j-api:1.7.30 -> >=dev-java/slf4j-api-1.7.30:0
# org.slf4j:slf4j-simple:1.7.24 -> >=dev-java/slf4j-simple-1.7.30:0

CP_DEPEND="
	dev-java/dom4j:1
	dev-java/gson:2.6
	dev-java/javassist:3
	dev-java/slf4j-api:0
	dev-java/slf4j-simple:0
"

# Compile dependencies
# POM: pom.xml
# javax.servlet:servlet-api:2.5 -> java-virtuals/servlet-api:2.5
# POM: pom.xml
# test? junit:junit:4.13 -> >=dev-java/junit-4.13.2:4

DEPEND="
	dev-java/tomcat-servlet-api:2.5
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

S="${WORKDIR}/${P}"

JAVA_CLASSPATH_EXTRA="tomcat-servlet-api-2.5"
JAVA_SRC_DIR=( "src/main/java" )

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR=( "src/test/java" )
JAVA_TEST_RESOURCE_DIRS=( "src/test/resources" )
JAVA_TEST_EXCLUDES=(
	# Upstream does not run this test
	"org.reflections.TestModel"
	# 1) testMethodParameterNames(org.reflections.ReflectionsCollectTest)
	# org.reflections.ReflectionsException: Scanner MethodParameterNamesScanner was not configured
	#         at org.reflections.Store.get(Store.java:39)
	#         at org.reflections.Store.get(Store.java:61)
	#         at org.reflections.Store.get(Store.java:46)
	#         at org.reflections.Reflections.getMethodParamNames(Reflections.java:579)
	#         at org.reflections.ReflectionsTest.testMethodParameterNames(ReflectionsTest.java:239)
	org.reflections.ReflectionsCollectTest
	# 2) testMethodParameterNames(org.reflections.ReflectionsParallelTest)
	# org.reflections.ReflectionsException: Scanner MethodParameterNamesScanner was not configured
	#         at org.reflections.Store.get(Store.java:39)
	#         at org.reflections.Store.get(Store.java:61)
	#         at org.reflections.Store.get(Store.java:46)
	#         at org.reflections.Reflections.getMethodParamNames(Reflections.java:579)
	#         at org.reflections.ReflectionsTest.testMethodParameterNames(ReflectionsTest.java:239)
	org.reflections.ReflectionsParallelTest
	# 3) testMethodParameterNames(org.reflections.ReflectionsTest)
	# org.reflections.ReflectionsException: Scanner MethodParameterNamesScanner was not configured
	#         at org.reflections.Store.get(Store.java:39)
	#         at org.reflections.Store.get(Store.java:61)
	#         at org.reflections.Store.get(Store.java:46)
	#         at org.reflections.Reflections.getMethodParamNames(Reflections.java:579)
	#         at org.reflections.ReflectionsTest.testMethodParameterNames(ReflectionsTest.java:239)
	org.reflections.ReflectionsTest
	#
	# https://github.com/ronmamo/reflections/issues/277#issuecomment-927152981
	# scanner was not configured exception - this is a known issue in 0.9.12, a simple workaround is to
	# check if the getStore() contains index for the scanner before querying. next version 0.10 fixes this.
)
