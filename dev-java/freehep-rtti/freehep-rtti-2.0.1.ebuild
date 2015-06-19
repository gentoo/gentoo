# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/freehep-rtti/freehep-rtti-2.0.1.ebuild,v 1.2 2014/08/10 20:13:23 slyfox Exp $

EAPI="5"

JAVA_PKG_IUSE=""
GROUP_ID="org.freehep"
MAVEN2_REPOSITORIES="http://java.freehep.org/maven2"

inherit java-pkg-2 java-mvn-src

DESCRIPTION="High Energy Physics Java library - Runtime Type Identification Object Model and API"
HOMEPAGE="http://java.freehep.org/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/bcel"

DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

JAVA_GENTOO_CLASSPATH="bcel"
