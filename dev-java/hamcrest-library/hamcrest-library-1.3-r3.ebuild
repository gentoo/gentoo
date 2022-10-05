# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.hamcrest:hamcrest-library:1.3"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Core library of matchers for building test expressions"
HOMEPAGE="https://hamcrest.org/JavaHamcrest/"
SRC_URI="https://github.com/hamcrest/JavaHamcrest/archive/hamcrest-java-${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ppc64 ~x86"

CP_DEPEND="dev-java/hamcrest-core:1.3"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

BDEPEND="dev-java/hamcrest-generator:1.3"

JAVA_SRC_DIR="${PN}/src"

DOCS=( {CHANGES,LICENSE,README}.txt )

PATCHES=(
	"${FILESDIR}"/hamcrest-library-1.3-r3-java-11.patch
)

S="${WORKDIR}/JavaHamcrest-hamcrest-java-${PV}"

src_prepare() {
	default
	java-pkg_clean
}

src_compile() {
	java-pkg-simple_src_compile

	# Generate "Matchers.java" (java-pkg-simple does not use the "build.xml" file)
	"$(java-config -J)" \
		-cp $(java-config --with-dependencies --classpath hamcrest-core:1.3,hamcrest-generator:1.3):${PN}.jar \
		org.hamcrest.generator.config.XmlConfigurator \
		matchers.xml \
		hamcrest-core/src/main/java,hamcrest-library/src/main/java \
		org.hamcrest.Matchers \
		hamcrest-library/src/main/java

	# Compile again, this time including the freshly generated "Matchers.java"
	java-pkg-simple_src_compile
}
