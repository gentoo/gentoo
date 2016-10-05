# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Free Java code coverage tool"
HOMEPAGE="http://emma.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm ppc64 x86 ~x86-fbsd"

IUSE="+launcher"

CDEPEND="
	dev-java/ant-core
	launcher? ( !sci-biology/emboss )"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

EANT_BUILD_TARGET="build"

java_prepare() {
	epatch "${FILESDIR}/${P}-java15api.patch"
	# bcp mangling unneccessary for 1.4+ and breaks with IBM 1.6 - bug #220463
	sed -e '/bootclasspathref/d' -e '/extdirs/d' -i build.xml || die
}

src_install() {
	java-pkg_dojar "dist/${PN}.jar"
	java-pkg_dojar "dist/${PN}_ant.jar"
	java-pkg_register-ant-task

	use launcher && java-pkg_dolauncher ${PN} --main emmarun

	# One of these does not have java sources
	use source && java-pkg_dosrc */*/com 2> /dev/null
}
