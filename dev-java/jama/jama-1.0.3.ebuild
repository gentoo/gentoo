# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jama/jama-1.0.3.ebuild,v 1.1 2013/06/11 13:55:47 tomwij Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit base java-pkg-2

MY_PN="Jama"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Java Matrix Package"
HOMEPAGE="http://math.nist.gov/javanumerics/jama/"
SRC_URI="http://math.nist.gov/javanumerics/${PN}/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}"

src_compile() {
	mkdir -p build || die

	ejavac -d build $(find Jama -name '*.java')

	$(java-config -j) cf ${MY_PN}.jar -C build ${MY_PN} || die
}

src_install() {
	java-pkg_dojar ${MY_PN}.jar

	dodoc Jama/ChangeLog

	use doc && java-pkg_dojavadoc Jama/doc
	use source && java-pkg_dosrc Jama
}
