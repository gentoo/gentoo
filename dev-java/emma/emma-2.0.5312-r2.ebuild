# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# No support for javadocs in build.xml
EAPI=2
JAVA_PKG_IUSE="source"

inherit base java-pkg-2 java-ant-2

DESCRIPTION="a free Java code coverage tool"
HOMEPAGE="http://emma.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"

IUSE="+launcher"

RDEPEND=">=virtual/jre-1.4
	>=dev-java/ant-core-1.7.0
	launcher? ( !sci-biology/emboss )"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"

EANT_BUILD_TARGET="build"

java_prepare() {
	epatch "${FILESDIR}/${P}-java15api.patch"
	# bcp mangling unneccessary for 1.4+ and breaks with IBM 1.6 - bug #220463
	sed -e '/bootclasspathref/d' -e '/extdirs/d' -i build.xml
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	java-pkg_dojar dist/${PN}_ant.jar
	java-pkg_register-ant-task
	use launcher && java-pkg_dolauncher ${PN} --main emmarun
	# One of these does not have java sources
	use source && java-pkg_dosrc */*/com 2> /dev/null
}
