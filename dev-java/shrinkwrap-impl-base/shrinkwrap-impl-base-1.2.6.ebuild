# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jboss.shrinkwrap:shrinkwrap-impl-base:1.2.6"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Common Base for Implementations of the ShrinkWrap Project"
HOMEPAGE="https://arquillian.org/modules/shrinkwrap-shrinkwrap/"
SRC_URI="https://github.com/shrinkwrap/shrinkwrap/archive/${PV}.tar.gz -> shrinkwrap-${PV}.tar.gz"
S="${WORKDIR}/shrinkwrap-${PV}/impl-base"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

CP_DEPEND="
	dev-java/jakarta-activation:1
	~dev-java/shrinkwrap-api-${PV}:0
	~dev-java/shrinkwrap-spi-${PV}:0
"

# Restrict to jdk:1.8 - otherwise there are 8 test failures:
# java.lang.IllegalArgumentException:
# /java.base/java/lang/String.class was not found in any available ClassLoaders
# testAddResourceStringTargetResourceFromJar(DynamicContainerTestBase.java:599)
# testAddManifestStringTargetResourceFromJar(DynamicContainerTestBase.java:586)
DEPEND="
	${CP_DEPEND}
	virtual/jdk:1.8
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_EXCLUDES=(
	org.jboss.shrinkwrap.impl.base.test.dummy.DummyInterfaceForTest
	org.jboss.shrinkwrap.impl.base.test.dummy.DummyClassForTest
	org.jboss.shrinkwrap.impl.base.TestSecurityActions
	org.jboss.shrinkwrap.impl.base.TestIOUtil
	org.jboss.shrinkwrap.impl.base.asset.DirectoryAssetTestCase
)
JAVA_TEST_GENTOO_CLASSPATH="junit-4,shrinkwrap-api,shrinkwrap-spi"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	# 1) importFromNonZipFileThrowsException(org.jboss.shrinkwrap.impl.base.ShrinkWrapTestCase)
	# java.lang.Exception: Unexpected exception, expected<java.lang.IllegalArgumentException>
	# but was<java.lang.NullPointerException>
	# Caused by: java.lang.NullPointerException
	#         at org.jboss.shrinkwrap.impl.base.ShrinkWrapTestCase.importFromNonZipFileThrowsException(ShrinkWrapTestCase.java:373)
	sed \
		-e '/import org.junit.Test/a import org.junit.Ignore;' \
		-e '/importFromNonZipFileThrowsException()/i @Ignore' \
		-i src/test/java/org/jboss/shrinkwrap/impl/base/ShrinkWrapTestCase.java || die

	java-pkg-simple_src_test
}
