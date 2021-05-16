# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FINDBUGS_PV="3.0.1"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Compile time checking for Java format strings"
SRC_URI="mirror://sourceforge/findbugs/findbugs-${FINDBUGS_PV}-source.zip"
HOMEPAGE="https://code.google.com/p/j-format-string"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*
	app-arch/unzip"

src_unpack() {
	unzip -qoj "${DISTDIR}/findbugs-${FINDBUGS_PV}-source.zip" "findbugs-${FINDBUGS_PV}/lib/jFormatString.jar" || die
	unpack ./jFormatString.jar
}

src_prepare() {
	default
	find -name "*.class" -delete || die
}
