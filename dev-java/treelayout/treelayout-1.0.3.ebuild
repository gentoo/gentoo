# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"
JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_PKG_BSFIX_NAME="build-impl.xml"
EANT_BUILD_XML="nbproject/build-impl.xml"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Efficiently create compact tree layouts in Java"
HOMEPAGE="https://github.com/abego/treelayout"
SRC_URI="https://github.com/abego/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/org.abego.${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*
	test? ( dev-java/ant-junit:0 )"

src_configure() {
	EANT_EXTRA_ARGS="-Dplatform.home=${JAVA_HOME}"
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar dist/org.abego.${PN}.core.jar
	dodoc CHANGES.txt src/website/abegoTreeLayout.pdf
	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src/main/java/*
}
