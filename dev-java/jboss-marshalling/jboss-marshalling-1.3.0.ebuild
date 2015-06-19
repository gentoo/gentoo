# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jboss-marshalling/jboss-marshalling-1.3.0.ebuild,v 1.1 2014/05/28 15:41:48 tomwij Exp $

EAPI="5"

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-pkg-simple

HOMEPAGE="http://jbossmarshalling.jboss.org/"
SRC_URI="http://download.jboss.org/jbossmarshalling/jboss-marshalling-${PV}.CR9-sources.jar"
DESCRIPTION="Alternative compatible serialization API that fixes many JDK serialization API problems"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CDEPEND="dev-java/jboss-modules:0"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"

JAVA_SRC_DIR="org"
JAVA_GENTOO_CLASSPATH="jboss-modules"
