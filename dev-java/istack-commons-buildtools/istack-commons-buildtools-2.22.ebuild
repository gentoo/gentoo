# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 java-pkg-simple

MY_PN=${PN%%-*}

DESCRIPTION="IStack Commons - Buildtools jar"
HOMEPAGE="https://istack-commons.java.net"
SRC_URI="https://maven.java.net/content/repositories/releases/com/sun/${MY_PN}/${PN}/${PV}/${P}-sources.jar"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/ant-core:0
	dev-java/codemodel:2"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"

JAVA_GENTOO_CLASSPATH="ant-core,codemodel-2"
