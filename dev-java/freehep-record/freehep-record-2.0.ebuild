# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE=""
GROUP_ID="org.freehep"
MAVEN2_REPOSITORIES="http://java.freehep.org/maven2"

inherit java-pkg-2 java-mvn-src

DESCRIPTION="High Energy Physics Java library - FreeHEP Record Manipulation Library"
HOMEPAGE="http://java.freehep.org/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/junit"
DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
JAVA_GENTOO_CLASSPATH="junit"
