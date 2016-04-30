# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="examples doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java library to launch Java classes"
HOMEPAGE="http://commons.apache.org/launcher/"
SRC_URI="mirror://apache/${PN%%-*}/${PN##*-}/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~x86-fbsd"
IUSE=""

CDEPEND="dev-java/ant-core:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

S="${WORKDIR}/${PN}"

JAVA_GENTOO_CLASSPATH="ant-core"

JAVA_SRC_DIR="src"

java_prepare() {
	java-pkg_clean
}

src_install() {
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples example
}
