# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Compatible alternative to the JDK serialization API"
HOMEPAGE="http://jbossmarshalling.jboss.org/"
SRC_URI="http://download.jboss.org/jbossmarshalling/${P}.CR9-sources.jar"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CDEPEND="dev-java/jboss-modules:0"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.7"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.7
	app-arch/unzip"

JAVA_GENTOO_CLASSPATH="jboss-modules"
