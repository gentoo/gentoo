# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/jidesoft/jide-oss/archive/19083238ce00ecbd7370f856cb64ea69dae669a5.tar.gz --slot 0 --keywords "~amd64 ~x86" --ebuild jide-oss.3.7.12-r2.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.jidesoft:jide-oss:3.7.12"
JAVA_TESTING_FRAMEWORKS="junit-4"
MY_COMMIT="19083238ce00ecbd7370f856cb64ea69dae669a5"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JIDE Common Layer (Professional Swing Components)"
HOMEPAGE="https://github.com/jidesoft/jide-oss"
SRC_URI="https://github.com/jidesoft/jide-oss/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Upstream does not support java-11
# https://github.com/jidesoft/jide-oss/issues/30
DEPEND="virtual/jdk:1.8"
RDEPEND="virtual/jre:1.8"

DOCS=( {LICENSE,'Readme JDK9',README}.txt libs/README_lib )

S="${WORKDIR}/${PN}-${MY_COMMIT}"

JAVA_GENTOO_CLASSPATH_EXTRA="libs/ui.jar"
JAVA_SRC_DIR=( "src" "src-jdk8" )
JAVA_RESOURCE_DIRS=( "src" "properties" )

JAVA_TEST_SRC_DIR="test"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"

JAVA_TEST_EXCLUDES=(
	"com.jidesoft.swing.CornerScrollerVisualTest" # No runnable methods
	"com.jidesoft.swing.TestResizableWindow" # No runnable methods
	"com.jidesoft.utils.TestCacheArray" # No runnable methods
	"com.jidesoft.utils.TestFontUtils"
)

src_prepare() {
	default
	rm libs/junit-4.10.jar || die
}

src_install() {
	default
	java-pkg-simple_src_install
}
