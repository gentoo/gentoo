# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jformatstring/jformatstring-2.0.3.ebuild,v 1.1 2015/03/14 14:58:54 chewi Exp $

EAPI=5

FINDBUGS_PV="3.0.1"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Compile time checking for Java format strings"
SRC_URI="mirror://sourceforge/findbugs/findbugs-${FINDBUGS_PV}-source.zip"
HOMEPAGE="http://code.google.com/p/j-format-string"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

src_unpack() {
	unzip -qoj "${DISTDIR}/findbugs-${FINDBUGS_PV}-source.zip" "findbugs-${FINDBUGS_PV}/lib/jFormatString.jar" || die
	unpack ./jFormatString.jar
}

java_prepare() {
	find -name "*.class" -delete || die
}
