# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.hamcrest:hamcrest-core:1.3"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Core library of matchers for building test expressions"
HOMEPAGE="https://hamcrest.org/JavaHamcrest/"
SRC_URI="https://github.com/hamcrest/JavaHamcrest/archive/hamcrest-java-${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="${PV}"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86 ~amd64-linux ~ppc-macos ~x64-macos ~x64-solaris"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="dev-java/hamcrest-generator:1.3"

DOCS=( {CHANGES,LICENSE,README}.txt )

PATCHES=(
	# https://bugs.gentoo.org/751379
	"${FILESDIR}"/hamcrest-core-1.3-r3-java-11.patch
)

S="${WORKDIR}/JavaHamcrest-hamcrest-java-${PV}"

JAVA_SRC_DIR="${PN}/src"

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
