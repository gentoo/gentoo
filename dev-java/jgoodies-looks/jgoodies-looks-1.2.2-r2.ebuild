# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jgoodies-looks/jgoodies-looks-1.2.2-r2.ebuild,v 1.1 2014/09/07 16:13:25 ercpe Exp $

EAPI=5

JAVA_PKG_IUSE="doc source examples"

inherit java-pkg-2 java-ant-2

MY_PN="looks"
MY_PV="${PV//./_}"

DESCRIPTION="JGoodies Looks Library"
HOMEPAGE="http://www.jgoodies.com/"
SRC_URI="http://www.jgoodies.com/download/libraries/${MY_PN}-${MY_PV}.zip"

LICENSE="BSD"
SLOT="1.2"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE="doc"

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${MY_PN}-${PV}"

EANT_DOC_TARGET="javadoc"

java_prepare() {
	find -name "*.jar" -delete || die
	cp "${FILESDIR}/build.xml" "${FILESDIR}/plastic.txt" "${S}" || die

	unzip ${MY_PN}-${PV}-src.zip || die
}

src_install() {
	java-pkg_dojar ${MY_PN}.jar

	dodoc RELEASE-NOTES.txt
	use source && java-pkg_dosrc com
	use doc && java-pkg_dohtml -r build/doc
	use examples && java-pkg_doexamples src/examples
}
