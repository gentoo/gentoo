# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/dtdparser/dtdparser-1.21-r2.ebuild,v 1.4 2015/04/21 18:35:23 pacho Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java DTD Parser"
HOMEPAGE="http://www.wutka.com/dtdparser.html"
SRC_URI="http://www.wutka.com/download/${P}.tgz"

LICENSE="LGPL-2.1 Apache-1.1"
SLOT="${PV}"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${P}"

JAVA_ENCODING="iso8859-1"
JAVA_SRC_DIR="source"

java_prepare() {
	find -name "*.jar" -o -name "*.class" -delete || die
	rm build.xml || die
}
