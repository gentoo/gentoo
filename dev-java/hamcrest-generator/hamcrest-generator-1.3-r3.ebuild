# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="source test"

inherit java-pkg-2 java-ant-2

MY_PN="hamcrest"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Code generator for Hamcrest's library of matchers for building test expressions"
HOMEPAGE="https://github.com/hamcrest"
SRC_URI="mirror://gentoo/${MY_P}.tgz"

LICENSE="BSD-2"
SLOT="${PV}"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~ppc-macos ~x64-macos"

CDEPEND="dev-java/qdox:1.12"

DEPEND=">=virtual/jdk-1.8:*
	userland_GNU? ( sys-apps/findutils )
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.8:*
	${CDEPEND}"

EANT_BUILD_TARGET="generator"
EANT_EXTRA_ARGS="-Dversion=${PV}"

src_prepare() {
	default
	# Don't include source in JAR.  If a Gentoo user wants the source the source
	# USE flag will be enabled.
	eapply "${FILESDIR}/${P}-no_jarjar.patch"

	find -iname "*.jar" -exec rm -v {} + || die "Unable to remove bundled JAR files"

	# These jars must be symlinked.  Specifying them using gentoo.classpath
	# does not work.
	java-pkg_jar-from --into lib/generator qdox-1.12 qdox.jar qdox-1.12.jar
}

src_install() {
	java-pkg_newjar build/${PN}-nodeps-${PV}.jar ${PN}.jar

	dodoc README.txt CHANGES.txt

	use source && java-pkg_dosrc ${PN}/src/main/java/org
}
