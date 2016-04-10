# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="${PN/jetty-/}"
MY_PV="${PV}.v20141010"
MY_P="${MY_PN}-${MY_PV}"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jetty's NPN API"
HOMEPAGE="http://www.eclipse.org/jetty/"
SRC_URI="http://central.maven.org/maven2/org/eclipse/jetty/npn/${MY_PN}/${MY_PV}/${MY_P}-sources.jar"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.7"

DEPEND=">=virtual/jdk-1.7
	app-arch/unzip"
