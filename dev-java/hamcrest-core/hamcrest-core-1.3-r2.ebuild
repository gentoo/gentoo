# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_PN="hamcrest"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Core library of matchers for building test expressions"
HOMEPAGE="https://github.com/hamcrest"
SRC_URI="mirror://gentoo/${MY_P}.tgz"

LICENSE="BSD-2"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~ppc-macos ~x64-macos"

DEPEND="~dev-java/hamcrest-generator-${PV}:1.3
	>=virtual/jdk-1.8:*
	userland_GNU? ( sys-apps/findutils )"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_CLASSPATH_TAGS="${JAVA_ANT_CLASSPATH_TAGS} java java-to-jar"

EANT_BUILD_TARGET="core"

PATCHES=(
	# https://bugs.gentoo.org/751379
	"${FILESDIR}"/hamcrest-core-1.3-java-11.patch
)

src_prepare() {
	default
	# Empty out the contents of the generator target; it has already been built.
	eapply "${FILESDIR}/hamcrest-1.3-empty_generator.patch"

	# Fix problems with Javadoc target.
	eapply "${FILESDIR}/hamcrest-core-1.3-fix_javadoc.patch"

	find -iname "*.jar" -exec rm -v {} + || die "Unable to clean bundled JAR files"

	local cp="build/${P}.jar"
	cp="${cp}:$(java-pkg_getjars --build-only --with-dependencies hamcrest-generator-${SLOT})"
	EANT_EXTRA_ARGS="-Dversion=${PV} -Dgentoo.classpath=${cp}"
}

src_install() {
	java-pkg_newjar build/${P}.jar ${PN}.jar

	dodoc README.txt CHANGES.txt

	use doc && java-pkg_dojavadoc build/temp/hamcrest-all-${PV}-javadoc.jar.contents
	use source && java-pkg_dosrc ${PN}/src/main/java/org
}
