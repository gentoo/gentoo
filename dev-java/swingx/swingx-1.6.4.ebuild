# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/swingx/swingx-1.6.4.ebuild,v 1.2 2014/08/10 20:25:22 slyfox Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A collection of powerful, useful, and just plain fun Swing components"
HOMEPAGE="https://java.net/projects/swingx/"
SRC_URI="https://java.net/projects/${PN}/downloads/download/releases/${PN}-all-${PV}-sources.jar
	https://java.net/projects/${PN}/downloads/download/releases/${PN}-mavensupport-${PV}-sources.jar"

LICENSE="LGPL-2.1"
SLOT="1.6"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/metainf-services:0"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"

JAVA_GENTOO_CLASSPATH="metainf-services"

src_install() {
	java-pkg_dojar ${PN}.jar

	use doc && java-pkg_dojavadoc target/api
	use source && java-pkg_dosrc org
}
