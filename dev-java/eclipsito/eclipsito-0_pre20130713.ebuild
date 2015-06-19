# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/eclipsito/eclipsito-0_pre20130713.ebuild,v 1.3 2015/04/02 18:06:40 mr_bones_ Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A small subset of Eclipse core libraries for modular applications"
HOMEPAGE="https://code.google.com/p/eclipsito/"
SRC_URI="http://dev.gentoo.org/~tomwij/files/dist/${P}.tar.xz"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

S="${WORKDIR}/${PN}/org.bardsoftware.${PN}"

java_prepare() {
	epatch "${FILESDIR}"/${P}-build.xml
}

src_install() {
	java-pkg_dojar ${PN}.jar

	use doc && java-pkg_dojavadoc apidocs
	use source && java-pkg_dosrc src/
}
