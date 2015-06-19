# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jsr101/jsr101-1.4-r2.ebuild,v 1.2 2015/06/13 09:44:33 zlogene Exp $

EAPI=5
JAVA_PKG_IUSE=""

inherit versionator java-pkg-2

DESCRIPTION="Java(TM) API for XML-Based RPC Specification Interface Classes"
HOMEPAGE="http://jcp.org/aboutJava/communityprocess/first/jsr101/"
MY_PN=axis
MY_PV=$(replace_all_version_separators _)
SRC_URI="mirror://apache/ws/${MY_PN}/${MY_PV}/${MY_PN}-src-${MY_PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"

IUSE=""

CDEPEND="java-virtuals/servlet-api:2.5
	java-virtuals/saaj-api:0"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_compile() {
	mkdir build
	ejavac \
		-classpath $(java-pkg_getjars servlet-api-2.5,saaj-api) \
		$(find src/javax/xml/rpc -name "*.java") -d build
	cd build
	jar cf jaxrpc-api.jar $(find . -type f) || die "jar failed"
}

src_install() {
	java-pkg_dojar build/*.jar
}
