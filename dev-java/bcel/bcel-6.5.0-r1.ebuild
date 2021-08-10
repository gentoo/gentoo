# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://ftp.wayne.edu/apache//commons/bcel/source/bcel-6.5.0-src.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris" --ebuild bcel-6.5.0-r1.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.bcel:bcel:6.5.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache Commons Bytecode Engineering Library"
HOMEPAGE="https://commons.apache.org/proper/commons-bcel"
SRC_URI="mirror://apache/commons/${PN}/source/${P}-src.tar.gz -> ${P}-sources.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# Compile dependencies
# POM: pom.xml
# test? javax:javaee-api:6.0 -> !!!groupId-not-found!!!
# test? junit:junit:4.13 -> >=dev-java/junit-4.13.1:4
# test? net.java.dev.jna:jna:5.5.0 -> !!!groupId-not-found!!!
# test? net.java.dev.jna:jna-platform:5.5.0 -> !!!groupId-not-found!!!
# test? org.apache.commons:commons-lang3:3.10 -> >=dev-java/commons-lang-3.11:3.6

DEPEND="
	>=virtual/jdk-1.8:*
	!arm? (
		!arm64? (
			!ppc64? (
				test? (
					dev-java/commons-collections:4
					dev-java/commons-lang:3.6
					dev-java/jna:4
					dev-java/jmh-core:0
					dev-java/oracle-javamail:0
				)
			)
		)
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

RESTRICT="!test? ( test ) arm? ( test ) arm64? ( test ) ppc64? ( test )"

S="${WORKDIR}/${P}-src"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="commons-collections-4,commons-lang-3.6,jmh-core,jna-4,junit-4,oracle-javamail"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS=(
	"src/test/resources"
)
JAVA_TEST_EXCLUDES=(
	# Invalid test class
	"org.apache.bcel.data.AnonymousClassTest"
	"org.apache.bcel.verifier.tests.TestArray01"
	"org.apache.bcel.verifier.tests.TestArrayAccess01"
	"org.apache.bcel.verifier.tests.TestArrayAccess02Creator"
	"org.apache.bcel.verifier.tests.TestArrayAccess03Creator"
	"org.apache.bcel.verifier.tests.TestArrayAccess04Creator"
	"org.apache.bcel.verifier.tests.TestLegalInvokeInterface01"
	"org.apache.bcel.verifier.tests.TestLegalInvokeSpecial01"
	"org.apache.bcel.verifier.tests.TestLegalInvokeSpecial02"
	"org.apache.bcel.verifier.tests.TestLegalInvokeStatic01"
	"org.apache.bcel.verifier.tests.TestLegalInvokeVirtual01"
	"org.apache.bcel.verifier.tests.TestLegalInvokeVirtual02"
	"org.apache.bcel.verifier.tests.TestReturn01Creator"
	"org.apache.bcel.verifier.tests.TestReturn02"
	"org.apache.bcel.verifier.tests.TestCreator"
	"org.apache.bcel.verifier.tests.TestReturn03Creator"
)
