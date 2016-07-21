# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java library for code generators"
HOMEPAGE="https://codemodel.java.net/"
SRC_URI="http://repo.maven.apache.org/maven2/com/sun/${PN}/${PN}/${PV}/${P}-sources.jar"

LICENSE="CDDL"
SLOT="2"
KEYWORDS="amd64 x86 ~x86-fbsd"

DEPEND=">=virtual/jdk-1.5
		app-arch/unzip"
RDEPEND=">=virtual/jre-1.5"
