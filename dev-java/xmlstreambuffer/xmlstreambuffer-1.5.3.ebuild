# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN=${PN/xml/}

DESCRIPTION="A stream-based representation of an XML infoset in Java"
HOMEPAGE="https://xmlstreambuffer.java.net/"
SRC_URI="https://maven.java.net/content/repositories/releases/com/sun/xml/stream/buffer/${MY_PN}/${PV}/${MY_PN}-${PV}-sources.jar"

LICENSE="CDDL GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

COMMON_DEP="dev-java/stax-ex:1"

DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

JAVA_GENTOO_CLASSPATH="stax-ex-1"
