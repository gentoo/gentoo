# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/milton-api/milton-api-2.6.5.5.ebuild,v 1.1 2015/07/06 09:52:27 monsieurp Exp $

EAPI="5"

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Milton WebDav library"
HOMEPAGE="http://milton.io"
SRC_URI="http://milton.io/maven/io/milton/${PN}/${PV}/${P}-sources.jar"

LICENSE="Apache-2.0"
SLOT="2.6"
KEYWORDS="~amd64 ~x86"

IUSE=""

CDEPEND="
	dev-java/commons-codec:0
	dev-java/commons-io:1
	dev-java/slf4j-api:0
"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.5"

JAVA_GENTOO_CLASSPATH="commons-codec,commons-io-1,slf4j-api"
