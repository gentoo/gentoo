# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-pkg-simple

MY_PN="xqj-api"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="XQuery API for Java"
HOMEPAGE="http://jcp.org/en/jsr/detail?id=225"
SRC_URI="https://github.com/cfoster/${MY_P}.0/raw/master/javax/xml/xquery/${MY_PN}/${PV}/${MY_P}-sources.jar -> ${P}.jar"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"

JAVA_ENCODING="ISO-8859-1"
