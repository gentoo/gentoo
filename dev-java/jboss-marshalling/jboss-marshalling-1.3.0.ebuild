# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-pkg-simple

HOMEPAGE="http://jbossmarshalling.jboss.org/"
SRC_URI="http://download.jboss.org/jbossmarshalling/jboss-marshalling-${PV}.CR9-sources.jar"
DESCRIPTION="Compatible alternative to the JDK serialization API"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

CDEPEND="dev-java/jboss-modules:0"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"

JAVA_SRC_DIR="org"
JAVA_GENTOO_CLASSPATH="jboss-modules"
