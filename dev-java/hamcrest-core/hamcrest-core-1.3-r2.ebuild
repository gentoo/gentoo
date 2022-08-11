# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.hamcrest:hamcrest-core:1.3"

inherit java-pkg-2 java-pkg-simple

MY_PN="hamcrest"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Core library of matchers for building test expressions"
HOMEPAGE="https://hamcrest.org/JavaHamcrest/"
SRC_URI="mirror://gentoo/${MY_P}.tgz"

LICENSE="BSD-2"
SLOT="${PV}"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~ppc-macos ~x64-macos"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND=">=dev-java/hamcrest-generator-${PV}:1.3"

JAVA_SRC_DIR="${PN}/src"

DOCS=( {CHANGES,LICENSE,README}.txt )

PATCHES=(
	# https://bugs.gentoo.org/751379
	"${FILESDIR}"/hamcrest-core-1.3-java-11.patch
)

src_prepare() {
	default
	java-pkg_clean
}

src_compile() {
	java-pkg-simple_src_compile

	# Need to add this in order to generate "CoreMatchers.java" as with java-ant-2 was triggered by "build.xml"
	"$(java-config -J)" \
		-cp $(java-config --with-dependencies --classpath hamcrest-generator:1.3):${PN}.jar \
		org.hamcrest.generator.config.XmlConfigurator \
		core-matchers.xml \
		hamcrest-core/src/main/java \
		org.hamcrest.CoreMatchers \
		hamcrest-core/src/main/java

	# Compile again, this time including the freshly generated "CoreMatchers.java"
	java-pkg-simple_src_compile
}

src_install() {
	default
	java-pkg-simple_src_install
}
