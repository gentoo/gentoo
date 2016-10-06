# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source examples"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Declarative Velocity Style Language."
HOMEPAGE="http://velocity.apache.org/dvsl/devel/"
SRC_URI="mirror://apache/velocity/dvsl/${PV}/${P}-src.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT="test"

CDEPEND="
	dev-java/ant-core:0
	dev-java/dom4j:1
	dev-java/velocity:0"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

S="${WORKDIR}/${P}-src"

JAVA_SRC_DIR="src"

JAVA_GENTOO_CLASSPATH="
	dom4j-1
	ant-core
	velocity
"

java_prepare() {
	java-pkg_clean
	rm -rv src/test || die
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher "${PN}" --main org.apache.dvsl.DVSL
	use examples && java-pkg_doexamples examples
}
