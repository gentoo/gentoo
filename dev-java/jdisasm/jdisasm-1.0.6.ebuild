# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/aunkrig/jdisasm/archive/5e354d659e4320d154b3f1fbff24c89c1ba48987.tar.gz --slot 0 --keywords "~amd64" --ebuild jdisasl-1.0.6.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="de.unkrig.jdisasm:jdisasm:1.0.6"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A disassembler for Java .class files"
HOMEPAGE="https://github.com/aunkrig/jdisasm"
MY_COMMIT="5e354d659e4320d154b3f1fbff24c89c1ba48987"
SRC_URI="https://github.com/aunkrig/jdisasm/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# There was 1 failure:
# 1) testWideLocals(jdisasm.Tests)
# java.lang.AssertionError: regex [(?m)^        iload_2         \[int l1\]$] not found in [
# // *** Disassembly of 'target/test-classes/subject/WideLocals.class'.
#
# // Class file version = 52.0 (Java 8)
#
# package subject;
#
# public class WideLocals extends Object {
#
#     public WideLocals() {
#         // Line 35
#         aload_0         [this]
#         invokespecial   Object()
#         return
#     }
#
#     public int methodWithOnlyAFewLocals(int p0) {
#         // Line 39
#         iconst_2
#         iload_1         [p0]
#         imul
#         istore_2        [v2]
#         // Line 40
#         iload_2         [v2]
#         ireturn
#     }
#
#     public int methodWithManyLocals(int p0) {
#         // Line 79
#         iconst_3
#         istore          [v202]
#         // Line 80
#         iconst_4
#         wide istore     [v272]
#         // Line 81
#         iload_1         [p0]
#         ireturn
#     }
# }
# ]
# 	at org.junit.Assert.fail(Assert.java:89)
# 	at de.unkrig.commons.junit4.AssertRegex.assertFind(AssertRegex.java:182)
# 	at de.unkrig.commons.junit4.AssertRegex.assertFind(AssertRegex.java:169)
# 	at jdisasm.Tests.testWideLocals(Tests.java:44)
#
# FAILURES!!!
# Tests run: 1,  Failures: 1
RESTRICT="test"

# Common dependencies
# POM: pom.xml
# de.unkrig.commons:commons-nullanalysis:1.2.13 -> >=dev-java/commons-nullanalysis-1.2.17:0

CP_DEPEND="
	dev-java/commons-nullanalysis:0
"

# Compile dependencies
# POM: pom.xml
# test? de.unkrig.commons:commons-junit4:1.2.13 -> >=dev-java/commons-junit4-1.2.17:0

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? (
		dev-java/commons-junit4:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

S="${WORKDIR}/jdisasm-${MY_COMMIT}/jdisasm"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="commons-junit4"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	# but it doesn't help :-(
	export LANG="C" LC_ALL="C"
	java-pkg-simple_src_test
}
