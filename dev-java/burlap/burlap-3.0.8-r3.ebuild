# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/burlap/burlap-3.0.8-r3.ebuild,v 1.5 2014/08/10 20:09:02 slyfox Exp $

EAPI=1

inherit base java-pkg-2 java-ant-2

DESCRIPTION="The Burlap web service protocol"
HOMEPAGE="http://www.caucho.com/burlap/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="Apache-1.1"
SLOT="3.0"
KEYWORDS="amd64 x86"

IUSE="doc source"

COMMON_DEP="java-virtuals/servlet-api:2.3
	dev-java/hessian:${PV}
	dev-java/caucho-services:3.0"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	dev-java/ant-core
	source? ( app-arch/zip )
	${COMMON_DEP}"

PATCHES=( "${FILESDIR}"/3.0.8-java5.patch )
JAVA_PKG_FILTER_COMPILER="jikes"

src_compile() {
	eant jar $(use_doc) -Dclasspath=$(java-pkg_getjars servlet-api-2.3,hessian-3.0.8,caucho-services-3.0)
}

src_install() {
	java-pkg_dojar dist/${PN}.jar

	use doc && java-pkg_dojavadoc dist/doc/api
	use source && java-pkg_dosrc src/*
}
