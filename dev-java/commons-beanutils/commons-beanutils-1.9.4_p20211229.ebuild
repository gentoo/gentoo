# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://apache/commons/beanutils/source/1.9.4-src.tar.gz --slot 1.7 --keywords "~amd64 ~x86 ~ppc64 ~amd64-linux ~x86-linux ~x64-macos" --ebuild commons-beanutils-1.9.4.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-beanutils:commons-beanutils:1.9.4"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

MY_COMMIT="df6c074342984749dec1de9ffc45ded556d86cfd"
DESCRIPTION="Provides easy-to-use wrappers around Reflection and Introspection APIs"
HOMEPAGE="https://commons.apache.org/proper/commons-beanutils/"
SRC_URI="https://github.com/apache/commons-beanutils/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1.7"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"

# Common dependencies
# POM: pom.xml
# commons-collections:commons-collections:3.2.2 -> >=dev-java/commons-collections-3.2.2:0
# commons-logging:commons-logging:1.2 -> >=dev-java/commons-logging-1.2:0

CP_DEPEND="
	dev-java/commons-collections:0
	dev-java/commons-logging:0
"

# Compile dependencies
# POM: pom.xml
# test? commons-collections:commons-collections-testframework:3.2.1 -> !!!artifactId-not-found!!!
# test? junit:junit:4.12 -> >=dev-java/junit-4.12:4

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/commons-collections:0[test]
	)"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( {CONTRIBUTING,README}.md {LICENSE,NOTICE,RELEASE-NOTES}.txt )

S="${WORKDIR}/${PN}-${MY_COMMIT}"

JAVA_ENCODING="iso-8859-1"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="commons-collections,junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

check_env() {
	if use test; then
		# this is needed only for tests
		CHECKREQS_MEMORY="1024M"
		check-reqs_pkg_pretend
	fi
}

pkg_pretend() {
	check_env
}

pkg_setup() {
	check_env
}

src_test() {
	# https://github.com/apache/commons-beanutils/blob/df6c074342984749dec1de9ffc45ded556d86cfd/pom.xml#L379-L381
	# <include>**/*TestCase.java</include>
	# <exclude>**/*MemoryTestCase.java</exclude>
	#
	# There was 1 failure:
	# 1) testMappedPropertyDescriptor_AnyArgsProperty(org.apache.commons.beanutils2.bugs.Jira347TestCase)
	# java.lang.OutOfMemoryError: Java heap space: failed reallocation of scalar replaced objects
	pushd src/test/java || die
		local TESTS=$(find * -name "*TestCase.java" ! -name "MemoryTestCase*" ! -name "*Jira347TestCase.java")
		TESTS="${TESTS//.java}"
		TESTS="${TESTS//\//.}"
	popd

	JAVA_TEST_RUN_ONLY=( "${TESTS}" )

	# There were 8 failures:
	# 1) testPropertyUtilsBean_descriptorsCache_memoryLeak(org.apache.commons.beanutils2.memoryleaktests.MemoryLeakTestCase)
	# java.lang.OutOfMemoryError: Java heap space: failed reallocation of scalar replaced objects
	# 2) testPropertyUtilsBean_mappedDescriptorsCache_memoryLeak(org.apache.commons.beanutils2.memoryleaktests.MemoryLeakTestCase)
	# java.lang.OutOfMemoryError: Java heap space: failed reallocation of scalar replaced objects
	# 3) testMappedPropertyDescriptor_MappedMethodReference1(org.apache.commons.beanutils2.memoryleaktests.MemoryLeakTestCase)
	# java.lang.OutOfMemoryError: Java heap space: failed reallocation of scalar replaced objects
	# 4) testMappedPropertyDescriptor_MappedMethodReference2(org.apache.commons.beanutils2.memoryleaktests.MemoryLeakTestCase)
	# java.lang.OutOfMemoryError: Java heap space: failed reallocation of scalar replaced objects
	# 5) testLocaleConvertUtilsBean_converters_memoryLeak(org.apache.commons.beanutils2.memoryleaktests.MemoryLeakTestCase)
	# java.lang.OutOfMemoryError: Java heap space: failed reallocation of scalar replaced objects
	# 6) testWrapDynaClass_dynaClasses_memoryLeak(org.apache.commons.beanutils2.memoryleaktests.MemoryLeakTestCase)
	# java.lang.OutOfMemoryError: Java heap space: failed reallocation of scalar replaced objects
	# 7) testMethodUtils_cache_memoryLeak(org.apache.commons.beanutils2.memoryleaktests.MemoryLeakTestCase)
	# java.lang.OutOfMemoryError: Java heap space: failed reallocation of scalar replaced objects
	# 8) testConvertUtilsBean_converters_memoryLeak(org.apache.commons.beanutils2.memoryleaktests.MemoryLeakTestCase)
	# java.lang.OutOfMemoryError: Java heap space: failed reallocation of scalar replaced objects
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if [[ "${vm_version}" == "11" ]] ; then
		JAVA_TEST_EXTRA_ARGS+=" -Xmx${CHECKREQS_MEMORY}"
	fi

	java-pkg-simple_src_test
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
