# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jutils/jutils-1.0.0.ebuild,v 1.1 2015/04/13 22:18:12 chewi Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Common utilities for the Java Game Technology Group"
HOMEPAGE="https://java.net/projects/jutils"
SRC_URI="http://search.maven.org/remotecontent?filepath=net/java/${PN}/${PN}/${PV}/${P}-sources.jar"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"
