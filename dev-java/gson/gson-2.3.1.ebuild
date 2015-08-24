# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java library to convert JSON to Java objects and vice-versa"
HOMEPAGE="https://code.google.com/p/google-gson/"
SRC_URI="http://search.maven.org/remotecontent?filepath=com/google/code/${PN}/${PN}/${PV}/${P}-sources.jar"
LICENSE="Apache-2.0"
SLOT="2.2.2"
KEYWORDS="amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

RDEPEND=">=virtual/jre-1.5"
