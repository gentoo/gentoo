# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/squareness-jlf/squareness-jlf-2.3.0-r1.ebuild,v 1.1 2014/03/08 16:37:36 tomwij Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Squareness Java Look and Feel"
HOMEPAGE="http://squareness.beeger.net/"
SRC_URI="mirror://sourceforge/squareness/${PN/-/_}_src-${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE="${JAVA_PKG_IUSE}"

S="${WORKDIR}"

RDEPEND=">=virtual/jre-1.4
	dev-java/laf-plugin:0"

DEPEND=">=virtual/jdk-1.4
	dev-java/laf-plugin:0"

EANT_GENTOO_CLASSPATH="laf-plugin"

java_prepare() {
	cp "${FILESDIR}"/build.xml build.xml || die
}

src_install() {
	java-pkg_dojar ${PN}.jar

	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc net
}
