# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Efficiently create compact tree layouts in Java"
SRC_URI="https://github.com/abego/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://github.com/abego/treelayout"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND=">=virtual/jre-1.6"

DEPEND=">=virtual/jdk-1.6
	test? ( dev-java/ant-junit:0 )"

S="${WORKDIR}/${P}/org.abego.${PN}"
JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_PKG_BSFIX_NAME="build-impl.xml"
EANT_BUILD_XML="nbproject/build-impl.xml"

src_configure() {
	EANT_EXTRA_ARGS="-Dplatform.home=${JAVA_HOME}"
}

src_install() {
	java-pkg_newjar dist/org.abego.${PN}.core.jar
	dodoc CHANGES.txt doc/abegoTreeLayout.pdf
	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src/main/java/*
}

src_test() {
	java-pkg-2_src_test
}
