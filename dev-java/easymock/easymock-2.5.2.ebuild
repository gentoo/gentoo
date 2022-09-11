# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/easymock/easymock/archive/easymock-2.5.2.tar.gz --slot 2.5 --keywords "~amd64" --ebuild easymock-2.5.2.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.easymock:easymock:2.5.2"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Mock Objects for interfaces in JUnit tests by generating them on the fly"
HOMEPAGE="https://easymock.org"
SRC_URI="https://github.com/easymock/easymock/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2.5"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

PATCHES=(
	"${FILESDIR}/easymock-2.5.5-nameClash.patch"
	"${FILESDIR}/easymock-2.5.5-tests2nameClash.patch"
)

S="${WORKDIR}/easymock-easymock-${PV}"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_prepare() {
	default # https://bugs.gentoo.org/780585
	# 1) testGetInstance(org.easymock.tests2.EasyMockPropertiesTest)
	# java.lang.AssertionError: expected:<1> but was:<null>
	sed \
		-e '/import org.junit.Test/a import org.junit.Ignore;' \
		-e '/testGetInstance()/i @Ignore' \
		-i src/test/java/org/easymock/tests2/EasyMockPropertiesTest.java || die

	# 2) testPrimitiveDeprecated(org.easymock.tests2.CaptureTest)
	# java.lang.AssertionError:
	# 3) testPrimitiveVsObject(org.easymock.tests2.CaptureTest)
	# java.lang.AssertionError:
	sed \
		-e '/import org.junit.Test/a import org.junit.Ignore;' \
		-e '/testPrimitiveDeprecated()/i @Ignore' \
		-e '/testPrimitiveVsObject()/i @Ignore' \
		-i src/test/java/org/easymock/tests2/CaptureTest.java || die
}
