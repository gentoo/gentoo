# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-pkg-simple

MY_PN=${PN/-library}
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Core library of matchers for building test expressions"
HOMEPAGE="https://github.com/hamcrest"
SRC_URI="mirror://gentoo/${MY_P}.tgz"

LICENSE="BSD-2"
SLOT="${PV}"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="dev-java/hamcrest-core:${SLOT}
	>=virtual/jdk-1.8:*
	userland_GNU? ( sys-apps/findutils )"
RDEPEND="dev-java/hamcrest-core:${SLOT}
	>=virtual/jre-1.8:*"
BDEPEND=">=dev-java/hamcrest-generator-${PV}:1.3"

JAVA_SRC_DIR="${PN}/src"
JAVA_GENTOO_CLASSPATH="hamcrest-core-1.3"

DOCS=( {CHANGES,LICENSE,README}.txt )

PATCHES=(
	"${FILESDIR}"/hamcrest-library-1.3-java-11.patch
)

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

src_install() {
	default
	java-pkg-simple_src_install
}
