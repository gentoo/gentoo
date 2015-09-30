# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Layout manager that makes creating user interfaces fast and easy"
HOMEPAGE="https://tablelayout.dev.java.net/"
SRC_URI="http://www.oracle.com/technetwork/java/${PN}.jar"
LICENSE="LGPL-2.1"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
SLOT="0"
IUSE=""

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

java_prepare() {
	find . -type f -name \*.class -exec rm -v {} \; || die

	# two commmas cause a compiling error :/
	sed -i -e 's#Dimension(40, 20);;#Dimension(40, 20);#g;' \
		example/TypicalGui.java || die
}
