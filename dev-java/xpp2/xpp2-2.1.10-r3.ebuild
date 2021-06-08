# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_PN="PullParser"
MY_P="${MY_PN}${PV}"

DESCRIPTION="A streaming pull XML parser used to quickly process input elements"
HOMEPAGE="http://www.extreme.indiana.edu/xgws/xsoap/xpp/mxp1/index.html"
SRC_URI="http://www.extreme.indiana.edu/xgws/xsoap/xpp/download/${MY_PN}2/${MY_P}.tgz"

LICENSE="Apache-1.1 IBM"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

# Some failures, partly because we haven't patched Xerces but probably
# also because this software is ancient. :(
RESTRICT="test"

CDEPEND="dev-java/xerces:2"
DEPEND=">=virtual/jdk-1.8:*
	test? ( dev-java/junit:4 )
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.8:*
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}-fix-java5+.patch"
)

EANT_GENTOO_CLASSPATH="xerces-2"
EANT_EXTRA_ARGS="-Dx2_present=true -Djunit.present=true"
EANT_BUILD_TARGET="intf intf_jar impl x2impl"
EANT_DOC_TARGET="api"
EANT_TEST_TARGET="junit"

src_prepare() {
	default

	rm -r build/ lib/ || die

	# Our usual rewriting stomps over the existing classpath, which
	# isn't helpful here.
	sed -i -r \
		-e 's/\bclasspath="/\0${gentoo.classpath}:/g' \
		-e 's/\$\{java\.class\.path\}/${gentoo.classpath}/g' \
		build.xml || die
}

src_install() {
	local suffix

	for suffix in "" -intf -standard -x2; do
		java-pkg_newjar build/lib/${MY_PN}${suffix}-${PV}.jar ${MY_PN}${suffix}.jar
	done

	dodoc README.html
	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc $(find src/java -name org -o -name javax)
}

src_test() {
	java-pkg-2_src_test
}
