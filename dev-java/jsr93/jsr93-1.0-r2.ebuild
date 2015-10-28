# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5
JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-pkg-simple

MY_PN="jaxr-api"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Java API for XML Registries (JAXR) - API"
HOMEPAGE="https://jcp.org/ja/jsr/detail?id=93"
SRC_URI="http://repo1.maven.org/maven2/org/apache/ws/scout/${MY_PN}/${PV}/${MY_P}-sources.jar"
LICENSE="sun-jsr93"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""
RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"
