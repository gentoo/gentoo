# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="net.sourceforge.htmlcleaner:htmlcleaner:2.26"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="HTML parser written in Java that can be used as a tool, library or Ant task"
HOMEPAGE="http://htmlcleaner.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/htmlcleaner/htmlcleaner/htmlcleaner%20v${PV}/htmlcleaner-${PV}-src.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

CP_DEPEND="dev-java/jdom:2"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DEPEND="
	${CP_DEPEND}
	dev-java/ant-core:0
	>=virtual/jdk-1.8:*
	test? ( dev-java/junit:4 )
"

BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}/${PN}-2.24-fix-tests.patch"
)

JAVA_CLASSPATH_EXTRA="ant-core"
JAVA_SRC_DIR="src/main/java"
JAVA_MAIN_CLASS="org.htmlcleaner.CommandLine"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"

src_prepare() {
	default # https://bugs.gentoo.org/780585
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_register-ant-task

	insinto "${JAVA_PKG_SHAREPATH}"
	newins example.xml default.xml
}
