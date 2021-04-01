# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2 java-utils-2

GWT_TOOLS_COMMIT="194772ed94078802d8030136796de344eb1fdbe1"
GWT_TOOLS_PN="tools"

DESCRIPTION="Google Web Toolkit library"
HOMEPAGE="http://www.gwtproject.org/"
SRC_URI="https://github.com/gwtproject/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/gwtproject/${GWT_TOOLS_PN}/archive/${GWT_TOOLS_COMMIT}.tar.gz -> ${PN}-${GWT_TOOLS_PN}-${GWT_TOOLS_COMMIT}.tar.gz"
# While the test suite does compile and does execute with an exit status of 0,
# there are many tests that end with FAILED status. It is unclear if this is
# expected from upstream or not, but in order to keep things honest, the test
# suite is being restricted
RESTRICT="mirror test"
SLOT="2.8"
LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

CDEPEND="
	dev-java/json:0
	dev-java/guava:20
	dev-java/rhino:1.6
	dev-java/asm:9
	dev-java/eclipse-ecj:4.5
	dev-java/validation-api:1.0
"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8:*"
DEPEND="
	${CDEPEND}
	virtual/jdk:1.8
"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_BUILD_TARGET="build"
EANT_GENTOO_CLASSPATH="
		json
		asm-9
		guava-20
		rhino-1.6
		eclipse-ecj-4.5
		validation-api-1.0
"

PATCHES=(
	"${FILESDIR}/${PN}-2.9.0-jsinterop-classpath.patch"
	"${FILESDIR}/${PN}-2.9.0-remove-git-usage.patch"
)

src_prepare() {
	default

	java-pkg-2_src_prepare
}

src_compile() {
	# the default setup assumes that you've placed these in ${S}/tools. We put
	# it in ${WORKDIR} though
	export GWT_TOOLS="${WORKDIR}/${GWT_TOOLS_PN}-${GWT_TOOLS_COMMIT}"
	export GWT_VERSION="${PV}"

	java-pkg-2_src_compile
}

src_test() {
	local -x ANT_OPTS=-Dfile.encoding=UTF-8
	local -x TZ=America/Los_Angeles

	java-pkg-2_src_test
}

src_install() {
	local i18nCreater_launcher_args=(
		i18nCreater
		--main com.google.gwt.i18n.tools.I18NCreater
		--jar gwt-dev.jar
		)
	local webAppCreator_launcher_args=(
		webAppCreator
		--main com.google.gwt.user.tools.WebAppCreator
		--jar gwt-dev.jar
	)

	java-pkg_dojar build/lib/*.jar
	java-pkg_dolauncher ${i18nCreater_launcher_args[@]}
	java-pkg_dolauncher ${webAppCreator_launcher_args[@]}
}
