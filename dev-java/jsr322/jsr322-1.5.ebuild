# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
JAVA_PKG_IUSE="source doc"

MY_PN="connector-api"
MY_P="${MY_PN}-${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java EE Connector Architecture"
HOMEPAGE="http://jcp.org/en/jsr/detail?id=322"
SRC_URI="https://repo1.maven.org/maven2/javax/resource/${MY_PN}/${PV}/${MY_P}-sources.jar -> ${P}.jar"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"
