# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Object Graph Navigation Library"
HOMEPAGE="https://ognl.orphan.software/"
SRC_URI="https://github.com/orphan-oss/ognl/archive/OGNL_${PV//./_}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/ognl-OGNL_${PV//./_}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

JAVACC_SLOT="7.0.13"
BDEPEND="dev-java/javacc:${JAVACC_SLOT}"

DEPEND="
	dev-java/javassist:3
	>=virtual/jdk-1.8:*
	test? (
		dev-java/easymock:2.5
		dev-java/hamcrest-core:1.3
	)
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="ognl"
JAVA_CLASSPATH_EXTRA="javassist-3"
JAVA_SRC_DIR="src/java"
JAVA_TEST_EXCLUDES=(
	# junit.framework.AssertionFailedError: No tests found in org.ognl.test.OgnlTestCase
	# org.junit.runners.model.InvalidTestClassError: Invalid test class 'org.ognl.test.objects.TestModel':
	# org.junit.runners.model.InvalidTestClassError: Invalid test class 'org.ognl.test.objects.TestInherited2':
	# org.junit.runners.model.InvalidTestClassError: Invalid test class 'org.ognl.test.objects.TestImpl':
	# org.junit.runners.model.InvalidTestClassError: Invalid test class 'org.ognl.test.objects.TestClass':
	# org.junit.runners.model.InvalidTestClassError: Invalid test class 'org.ognl.test.objects.TestInherited1':
	ognl.Java8Test
	org.ognl.test.OgnlTestCase
	org.ognl.test.objects.TestModel
	org.ognl.test.objects.TestInherited2
	org.ognl.test.objects.TestImpl
	org.ognl.test.objects.TestClass
	org.ognl.test.objects.TestInherited1
)
JAVA_TEST_GENTOO_CLASSPATH="easymock-2.5 hamcrest-core-1.3 junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	"javacc-${JAVACC_SLOT}" \
		-GRAMMAR_ENCODING=UTF-8 \
		-LOOKAHEAD=1, -STATIC=false \
		-JAVA_UNICODE_ESCAPE=true \
		-UNICODE_INPUT=true \
		-OUTPUT_DIRECTORY=src/main/java \
		src/java/ognl/ognl.jj || die "javacc"
}

src_test() {
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 21; then
		# This file has 30 tets, 5 of which would fail with higher Java versions.
		eapply "${FILESDIR}/ognl-3.1.24-TestOgnlRuntime.patch"
	fi
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=(
			--add-opens=java.base/java.lang=ALL-UNNAMED
			--add-opens=java.base/java.util=ALL-UNNAMED
		)
	fi
	java-pkg-simple_src_test
}
