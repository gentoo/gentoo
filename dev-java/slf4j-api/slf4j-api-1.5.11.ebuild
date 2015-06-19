# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/slf4j-api/slf4j-api-1.5.11.ebuild,v 1.5 2010/10/14 16:59:11 ranger Exp $

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Simple Logging Facade for Java"
HOMEPAGE="http://www.slf4j.org/"
# Extract from http://www.slf4j.org/dist/${P/-api/}.tar.gz
SRC_URI="mirror://gentoo/${P}-sources.jar"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"

S="${WORKDIR}"

java_prepare() {
	cp -v "${FILESDIR}"/build.xml . || die
}

src_install() {
	java-pkg_dojar ${PN}.jar
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc org
}
