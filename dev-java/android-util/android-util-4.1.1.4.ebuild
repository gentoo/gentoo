# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit java-pkg-2 java-pkg-simple

MY_PN="${PN/-util}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Library providing APIs for applications written for Google Android"
HOMEPAGE="http://source.android.com/"
SRC_URI="http://central.maven.org/maven2/com/google/${MY_PN}/${MY_PN}/${PV}/${MY_P}-sources.jar"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/xerces:2
	dev-java/xpp3:0"

DEPEND=">=virtual/jdk-1.7
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.7
	${CDEPEND}"

JAVA_SRC_DIR="${MY_PN}/util"

JAVA_GENTOO_CLASSPATH="xerces-2,xpp3"
