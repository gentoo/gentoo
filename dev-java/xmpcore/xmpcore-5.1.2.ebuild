# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java library based on the Adobe C++ XMPCore library with a similar API"
HOMEPAGE="http://www.adobe.com/devnet/xmp.html"
SRC_URI="http://central.maven.org/maven2/com/adobe/xmp/${PN}/${PV}/${P}-sources.jar"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"
