# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Common utilities for the Java Game Technology Group"
HOMEPAGE="https://java.net/projects/jutils"
SRC_URI="http://central.maven.org/maven2/net/java/${PN}/${PN}/${PV}/${P}-sources.jar"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip"
