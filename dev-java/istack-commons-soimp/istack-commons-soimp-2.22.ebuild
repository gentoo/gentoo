# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/istack-commons-soimp/istack-commons-soimp-2.22.ebuild,v 1.2 2015/06/12 16:08:37 monsieurp Exp $

EAPI=5

inherit java-pkg-2 java-pkg-simple

MY_PN=${PN%%-*}

DESCRIPTION="IStack Commons - Soimp jar"
HOMEPAGE="https://istack-commons.java.net"
SRC_URI="https://maven.java.net/content/repositories/releases/com/sun/${MY_PN}/${PN}/${PV}/${P}-sources.jar"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

CDEPEND="dev-java/ant-core:0
	dev-java/args4j:2"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"

JAVA_GENTOO_CLASSPATH="ant-core,args4j-2"
