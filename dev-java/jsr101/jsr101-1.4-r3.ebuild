# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java(TM) API for XML-Based RPC Specification Interface Classes"
HOMEPAGE="http://jcp.org/aboutJava/communityprocess/first/jsr101/"
SRC_URI="http://dev.gentoo.org/~monsieurp/packages/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

CDEPEND="
	java-virtuals/servlet-api:3.0
	java-virtuals/saaj-api:0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

JAVA_SRC_DIR="src"
JAVA_GENTOO_CLASSPATH="
	servlet-api-3.0
	saaj-api
"
