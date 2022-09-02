# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/jnr/jnr-posix/archive/jnr-posix-3.1.15.tar.gz --slot 3.0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild jnr-posix-3.1.15.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.github.jnr:jnr-posix:3.1.15"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Common cross-project/cross-platform POSIX APIs"
HOMEPAGE="https://github.com/jnr/jnr-posix"
SRC_URI="https://github.com/jnr/${PN}/archive/${P}.tar.gz"

LICENSE="EPL-2.0 GPL-2 LGPL-2.1"
SLOT="3.0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CP_DEPEND="
	>=dev-java/jnr-ffi-2.2.12:2
	dev-java/jnr-constants:0
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-11:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

S="${WORKDIR}/${PN}-${P}"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	sed \
		-e '/import org.junit.Test/a import org.junit.Ignore;' \
		-i src/test/java/jnr/posix/FileTest.java || die

	if use ppc64; then
		# Ignore testMessageHdrMultipleControl
		# https://bugs.gentoo.org/866199
		# https://github.com/jnr/jnr-posix/issues/178
		sed \
			-e '/testMessageHdrMultipleControl/i @Ignore' \
			-e '/import org.junit.Test/a import org.junit.Ignore;' \
			-i src/test/java/jnr/posix/LinuxPOSIXTest.java || die
	fi

	if use arm; then
		# https://bugs.gentoo.org/866692
		sed \
			-e '/utimensatRelativePath()/i @Ignore' \
			-e '/utimesDefaultValuesTest()/i @Ignore' \
			-e '/futimeTest()/i @Ignore' \
			-e '/utimesTest()/i @Ignore' \
			-e '/utimesPointerTest()/i @Ignore' \
			-e '/utimensatAbsolutePath()/i @Ignore' \
			-e '/futimens()/i @Ignore' \
			-i src/test/java/jnr/posix/FileTest.java || die
		sed \
			-e '/import org.junit.Test/a import org.junit.Ignore;' \
			-e '/ioprioThreadedTest()/i @Ignore' \
			-e '/testPosixFadvise()/i @Ignore' \
			-i src/test/java/jnr/posix/LinuxPOSIXTest.java || die
		sed \
			-e '/import org.junit.Test/a import org.junit.Ignore;' \
			-e '/testSetRlimitPointerLinux()/i @Ignore' \
			-e '/testGetRLimitPointer()/i @Ignore' \
			-i src/test/java/jnr/posix/ProcessTest.java || die
	fi

	JAVA_TEST_EXCLUDES=(
		# https://github.com/jnr/jnr-posix/blob/jnr-posix-3.1.15/pom.xml#L185
		# <exclude>**/windows/*Test.java</exclude>
		"jnr.posix.windows.WindowsFileTest"
		"jnr.posix.windows.WindowsHelpersTest"
		# Next 3 tests need to run separately, otherwise would fail.
		"jnr.posix.GroupTest"
		"jnr.posix.NlLanginfoTest"
		"jnr.posix.SpawnTest"
	)
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if [[ "${vm_version}" -ge "17" ]] ; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.io=ALL-UNNAMED )
		# Some tests in jnr.posix.FileTest fail with jdk-17
		eapply "${FILESDIR}/jnr-posix-3.1.15-FileTest.patch"
	fi
	java-pkg-simple_src_test
	JAVA_TEST_RUN_ONLY="jnr.posix.SpawnTest"
	java-pkg-simple_src_test
	JAVA_TEST_RUN_ONLY="jnr.posix.NlLanginfoTest"
	java-pkg-simple_src_test
	JAVA_TEST_RUN_ONLY="jnr.posix.GroupTest"
	java-pkg-simple_src_test
}
