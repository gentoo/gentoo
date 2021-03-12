# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Library for testing Java code using mock objects"
HOMEPAGE="http://jmock.org"
SRC_URI="http://jmock.org/downloads/${P}-jars.zip"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

CDEPEND="dev-java/hamcrest-core:1.3
	dev-java/hamcrest-library:1.3
	dev-java/junit:4"

RDEPEND=">=virtual/jre-1.8:*
	${CDEPEND}"

DEPEND="app-arch/unzip
	>=virtual/jdk-1.8:*
	${CDEPEND}"

JAVA_GENTOO_CLASSPATH="hamcrest-core-1.3,hamcrest-library-1.3,junit-4"

S="${WORKDIR}/${P}"

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	unzip ${P}.jar -d src || die
	rm *.jar || die
}

src_prepare() {
	default
	find -name "*.class" -delete || die
}
