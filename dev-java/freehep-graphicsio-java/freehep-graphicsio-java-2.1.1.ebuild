# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE=""
GROUP_ID="org.freehep"
MAVEN2_REPOSITORIES="http://java.freehep.org/maven2"

inherit java-pkg-2 java-mvn-src

DESCRIPTION="High Energy Physics Java library - FreeHEP Java Driver"
HOMEPAGE="http://java.freehep.org/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND=">=dev-java/freehep-graphicsio-2.1.1
	>=dev-java/freehep-graphicsio-tests-2.1.1
	dev-java/junit
	dev-java/freehep-util
	dev-java/freehep-swing
	dev-java/freehep-graphics2d
	dev-java/freehep-io
	dev-java/freehep-export"
DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
JAVA_GENTOO_CLASSPATH="freehep-graphicsio,freehep-graphicsio-tests,junit,freehep-util,freehep-swing,freehep-graphics2d,freehep-io,freehep-export"
