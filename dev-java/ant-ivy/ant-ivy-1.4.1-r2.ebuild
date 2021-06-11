# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc examples source test"

# Registers as split-ant task.
WANT_SPLIT_ANT="true"

# Rewrites examples otherwise... bad.
JAVA_PKG_BSFIX_ALL="no"

inherit java-pkg-2 java-ant-2

MY_PN="${PN##*-}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Ivy is a free java based dependency manager"
HOMEPAGE="https://ant.apache.org/ivy/"
SRC_URI="http://www.jaya.free.fr/downloads/ivy/${PV}/${MY_P}-src.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux"

COMMON_DEP="
	dev-java/ant-core:0
	dev-java/commons-cli:1
	dev-java/commons-httpclient:3
	dev-java/commons-vfs:0
	dev-java/jakarta-oro:2.0
	dev-java/jsch:0"

BDEPEND="app-arch/unzip"
DEPEND="
	>=virtual/jdk-1.8:*
	test? ( dev-java/ant-junit:0 )
	${COMMON_DEP}"

RDEPEND=">=virtual/jre-1.8:*
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/1.4.1-javadoc.patch"
)

src_prepare() {
	default

	# init-ivy expects existing ivy.jar, but we don't need actually it
	sed -i -e 's/depends="init-ivy, prepare"/depends="prepare"/' build.xml \
		|| die

	rm -v src/java/fr/jayasoft/ivy/repository/vfs/IvyWebdav* || die
	java-ant_rewrite-classpath
	mkdir lib
}

EANT_GENTOO_CLASSPATH="
	ant-core,commons-cli-1,commons-httpclient-3
	commons-vfs,jakarta-oro-2.0,jsch"

EANT_BUILD_TARGET="offline jar"

src_test() {
	# TODO: find out why a couple of these fail
	java-pkg_jar-from --into lib junit
	ANT_TASKS="ant-junit" eant offline test
}

src_install() {
	java-pkg_dojar build/artifact/${MY_PN}.jar

	use doc && java-pkg_dojavadoc doc/ivy/api
	use examples && java-pkg_doexamples src/example
	use source && java-pkg_dosrc src/java/*

	java-pkg_register-ant-task
}
