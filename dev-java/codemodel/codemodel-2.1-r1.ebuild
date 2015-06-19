# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/codemodel/codemodel-2.1-r1.ebuild,v 1.1 2014/09/06 07:44:01 ercpe Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java library for code generators"
HOMEPAGE="https://codemodel.java.net/"
SRC_URI="http://repo.maven.apache.org/maven2/com/sun/${PN}/${PN}/${PV}/${P}-sources.jar"

LICENSE="CDDL"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"

DEPEND=">=virtual/jdk-1.5
		app-arch/unzip"
RDEPEND=">=virtual/jre-1.5"
