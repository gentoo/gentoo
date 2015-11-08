# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JAX-RS: Java API for RESTful Web Services"
HOMEPAGE="http://jcp.org/en/jsr/detail?id=311"
SRC_URI="http://repo1.maven.org/maven2/javax/ws/rs/${PN}/${PV}/${P}-sources.jar"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"
