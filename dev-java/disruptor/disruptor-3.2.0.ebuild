# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="High Performance Inter-Thread Messaging Library"
HOMEPAGE="http://lmax-exchange.github.io/disruptor/"
SRC_URI="http://repo1.maven.org/maven2/com/lmax/${PN}/${PV}/${P}-sources.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"
