# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://bitbucket.org/asomov/snakeyaml/get/snakeyaml-1.28.tar.gz --slot 0 --keywords "~amd64 ~x86" --ebuild snakeyaml-1.28-r1.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.yaml:snakeyaml:1.28"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

MY_COMMIT="b28f0b4d87c6"
MY_P="asomov-snakeyaml-${MY_COMMIT}"

DESCRIPTION="YAML 1.1 parser and emitter for Java"
HOMEPAGE="https://bitbucket.org/asomov/snakeyaml"
SRC_URI="https://bitbucket.org/asomov/${PN}/get/${P}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 x86"

# Compile dependencies
# POM: pom.xml
# test? commons-io:commons-io:2.5 -> >=dev-java/commons-io-2.4:1
# test? joda-time:joda-time:2.10.1 -> >=dev-java/joda-time-2.10.10:0
# test? junit:junit:4.13.1 -> >=dev-java/junit-4.13.1:4
# test? org.apache.commons:commons-lang3:3.4 -> >=dev-java/commons-lang-3.4:3.4
# test? org.apache.velocity:velocity:1.6.2 -> >=dev-java/velocity-1.7:0

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/commons-io-2.4:1
		dev-java/commons-lang:3.6
		>=dev-java/joda-time-2.10.10:0
		>=dev-java/velocity-1.7:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}-fix-test-check.patch"
)

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="commons-io-1,joda-time,junit-4,commons-lang-3.6,velocity"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

JAVA_TEST_EXCLUDES=(
	"examples.spring.TestEntityDescription"	# Invalid test class
	"org.yaml.snakeyaml.constructor.TestBean1"	# Invalid test class
	"org.yaml.snakeyaml.introspector.TestAnnotation"	# Invalid test class
	"org.yaml.snakeyaml.introspector.TestBean"	# Invalid test class
	"org.yaml.snakeyaml.ruby.TestObject"	# Invalid test class
	"org.yaml.snakeyaml.issues.issue154.TestBean"	# Invalid test class
	"org.yaml.snakeyaml.issues.issue193.TestYaml"	# Invalid test class

	# initializationError(org.yaml.snakeyaml.constructor.TestBean)
	# java.lang.IllegalArgumentException: Test class can only have one constructor
	"org.yaml.snakeyaml.constructor.TestBean"

	# testTemplate1(org.yaml.snakeyaml.emitter.template.VelocityTest)
	# java.lang.NullPointerException
	"org.yaml.snakeyaml.emitter.template.VelocityTest"

	# yamlClassInYAMLCL(org.yaml.snakeyaml.issues.issue318.ContextClassLoaderTest)
	# java.lang.ClassNotFoundException: org.yaml.snakeyaml.Yaml
	"org.yaml.snakeyaml.issues.issue318.ContextClassLoaderTest"

	"examples.spring.TestEntity"	# Invalid test class

	"org.pyyaml.PyImportTest"	# No tests found in org.pyyaml.PyImportTest
)

src_prepare() {
	default
	java-utils-2_src_prepare
}

src_test() {
	export EnvironmentKey1="EnvironmentValue1"
	export EnvironmentEmpty=""
	java-pkg-simple_src_test
}
