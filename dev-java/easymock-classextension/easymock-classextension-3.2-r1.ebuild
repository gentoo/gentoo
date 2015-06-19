# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/easymock-classextension/easymock-classextension-3.2-r1.ebuild,v 1.2 2015/04/02 18:05:57 mr_bones_ Exp $

EAPI="5"

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple

MY_PN=${PN/-}
MY_P=${MY_PN}-${PV}
DESCRIPTION="Provides Mock Objects for interfaces in JUnit tests by generating them on the fly"
HOMEPAGE="http://www.easymock.org/"
SRC_URI="mirror://sourceforge/easymock/EasyMock%20Class%20Extension/${PV}/${MY_P}.zip"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="3.2"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/easymock:${SLOT}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

JAVA_GENTOO_CLASSPATH="easymock-${SLOT}"
JAVA_SRC_DIR="src"

src_unpack() {
	default

	cd "${S}" || die
	unzip ${MY_P}-sources.jar -d src/ || die

	if use examples; then
		unzip ${MY_P}-samples.jar -d examples/ || die
	fi
}

src_install() {
	java-pkg-simple_src_install

	use examples && java-pkg_doexamples examples
}
