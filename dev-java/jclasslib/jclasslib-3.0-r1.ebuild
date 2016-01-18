# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

MY_PV=${PV/./_}
DESCRIPTION="A bytecode viewer is a tool"
HOMEPAGE="http://www.ej-technologies.com/products/jclasslib/overview.html"
SRC_URI="mirror://sourceforge/${PN}/${PN}_unix_${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -v bin/*.jar lib-compile/*.jar .install4j/*.jar || die
	epatch "${FILESDIR}/${PN}-3.0-buildxml.patch"
	epatch "${FILESDIR}/3.0-browser.patch"
}

src_install() {
	java-pkg_dojar build/${PN}.jar

	#-pre relies on -java_args not being used
	#if you need that, patch java-utils-2.eclass
	java-pkg_dolauncher ${PN} \
		-pre "${FILESDIR}/3.0-pre"

	# has stuff other than javadoc too
	use doc && java-pkg_dohtml -r doc/*
	use source && java-pkg_dosrc src/*
}

pkg_postinst() {
	elog "jclasslib by default uses firefox as the browser."
	elog "Use the BROWSER environment variable to use something else."
}
