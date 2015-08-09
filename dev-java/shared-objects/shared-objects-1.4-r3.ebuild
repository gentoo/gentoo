# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A Java Class implementing a core factory for maximal sharing of arbitrary objects"
HOMEPAGE="http://www.cwi.nl/htbin/sen1/twiki/bin/view/SEN1/ATermLibrary"
SRC_URI="http://www.cwi.nl/projects/MetaEnv/shared-objects/shared-objects-1.4.tar.gz"
LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="amd64 ~ppc x86"

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

src_unpack() {
	unpack ${A}
	cp "${FILESDIR}/build.xml" "${S}" || die

	(
		echo "#! /bin/sh"
		echo "java-config -p shared-objects-1"
	) > "${S}"/shared-objects-config
}

src_install() {
	java-pkg_dojar shared-objects.jar
	dobin shared-objects-config || die

	dodoc AUTHORS ChangeLog || die
	use source && java-pkg_dosrc "${S}/shared"
}
