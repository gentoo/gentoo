# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.easymock:easymock:3.3.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Mock Objects for interfaces in JUnit tests by generating them on the fly"
HOMEPAGE="https://easymock.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="3.2"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CDEPEND="
	dev-java/cglib:3
	dev-java/junit:4
	dev-java/objenesis:0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}
"

S="${WORKDIR}/${PN}-${P}"

JAVA_ENCODING="ISO-8859-1"

JAVA_GENTOO_CLASSPATH="cglib-3,junit-4,objenesis"
JAVA_SRC_DIR=(
	"${PN}/src/main/java"
	"${PN}/src/samples/java"
)

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="${PN}/src/test/java"
JAVA_TEST_EXCLUDES=(
	"org.easymock.tests2.EasyMockAnnotationsTest" # "java.lang.InstantiationException" (12 x)
	"org.easymock.tests.BaseEasyMockRunnerTest" # No runnable methods
)

src_prepare() {
	default
	# error: package com.google.dexmaker.stock does not exist
	eapply "${FILESDIR}"/3.3.1-r1-no-android.patch
	rm easymock/src/main/java/org/easymock/internal/AndroidClassProxyFactory.java || die
	# cannot find symbol   o = ProxyBuilder.forClass(ArrayList.class)
	rm easymock/src/test/java/org/easymock/tests2/ClassExtensionHelperTest.java || die
}

src_test() {
	# ClassLoader.defineClass(java.lang.String,byte[],int,int,java.security.ProtectionDomain) throws
	# java.lang.ClassFormatError accessible: module java.base does not "opens java.lang" to unnamed module @66da75e4
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.io=ALL-UNNAMED )
	fi
	java-pkg-simple_src_test
}
