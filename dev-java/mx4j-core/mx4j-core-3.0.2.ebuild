# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils java-pkg-2 java-ant-2

MY_PN="${PN/-core/}"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Open Source implementation of the JMX and JMX Remote API (JSR 160) specifications"
HOMEPAGE="http://mx4j.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}-src.tar.gz"

# The ${S}/BUILD-HOWTO is a good source for dependencies
# This package could also be built with jdk-1.3; see special
# handling instructions in ${S}/BUILD-HOWTO.

RDEPEND="dev-java/bcel
	dev-java/commons-logging
	dev-java/log4j"
DEPEND="${RDEPEND}
	>=virtual/jdk-1.5
	>=dev-java/ant-core-1.6
	source? ( app-arch/zip )"
RDEPEND="${RDEPEND}
	>=virtual/jre-1.5"

LICENSE="Apache-1.1"
SLOT="3.0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="doc source"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/${P}-split-javadoc-build.patch"

	cd "${S}/lib"
	java-pkg_jar-from bcel bcel.jar
	java-pkg_jar-from commons-logging commons-logging.jar
	java-pkg_jar-from log4j
}

src_compile() {
	eant -f build/build.xml compile.jmx compile.rjmx $(use_doc javadocs.core)
}

src_install() {
	java-pkg_dojar dist/lib/*.jar
	dodoc README.txt
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc "${S}/src/core/*"
}

pkg_postinst() {
	elog "This is a a new split ebuild for just the core jmx to reduce"
	elog "dependencies for packages that only require the core. You can"
	elog "find the examples in dev-java/mx4j and the tools in dev-java/mx4j-tools"
}
