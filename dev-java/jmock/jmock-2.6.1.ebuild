# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jmock/jmock-2.6.1.ebuild,v 1.4 2015/04/22 10:18:39 monsieurp Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Library for testing Java code using mock objects"
SRC_URI="http://www.jmock.org/downloads/${P}-jars.zip"
HOMEPAGE="http://www.jmock.org"

LICENSE="BSD"
SLOT="2"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="dev-java/hamcrest-core:1.3
	dev-java/hamcrest-library:1.3
	dev-java/junit:4"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}
	app-arch/unzip"

JAVA_GENTOO_CLASSPATH="hamcrest-core-1.3,hamcrest-library-1.3,junit-4"

S="${WORKDIR}/${P}"

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	unzip ${P}.jar -d src || die
	rm *.jar || die
}

src_prepare() {
	find -name "*.class" -delete || die
}
