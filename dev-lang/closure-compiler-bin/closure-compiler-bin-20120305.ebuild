# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit java-pkg-2

DESCRIPTION="JavaScript optimizing compiler"
HOMEPAGE="http://code.google.com/p/closure-compiler/"
SRC_URI="http://closure-compiler.googlecode.com/files/compiler-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"

S=${WORKDIR}

src_install() {
	java-pkg_jarinto /opt/${PN}-${SLOT}/lib
	java-pkg_newjar compiler.jar ${PN}.jar
	java-pkg_dolauncher \
		${PN%-bin} \
		--jar /opt/${PN}-${SLOT}/lib/${PN}.jar \
		-into /opt
	dodoc README
}
