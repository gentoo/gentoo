# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Simple Logging Facade for Java"
HOMEPAGE="http://www.slf4j.org/"
# Extract from http://www.slf4j.org/dist/${P/-api/}.tar.gz
#SRC_URI="mirror://gentoo/${P}-sources.jar"
SRC_URI="http://www.slf4j.org/dist/${P/-api/}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"

S="${WORKDIR}/${P/-api/}/${PN}"

java_prepare() {
	cp -v "${FILESDIR}"/${PN}_maven-build.xml build.xml || die
	find "${WORKDIR}" -iname '*.jar' -delete
}

src_install() {
	java-pkg_newjar target/${P}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/org
}
