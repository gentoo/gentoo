# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sblim-cim-client/sblim-cim-client-2.2.1.ebuild,v 1.1 2013/02/07 17:01:18 sera Exp $

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A WBEM services client that includes an IETF RFC 2614 compliant SLP client for CIM service discovery"
HOMEPAGE="http://sblim.wiki.sourceforge.net/CimClient"
SRC_URI="mirror://sourceforge/sblim/${PN}2-${PV}-src.zip"

LICENSE="CPL-1.0"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=virtual/jre-1.5"
DEPEND="
	>=virtual/jdk-1.5
	test? ( dev-java/ant-junit )"

S="${WORKDIR}/${PN}2-${PV}-src"

EANT_BUILD_TARGET="package"
EANT_DOC_TARGET="java-doc"

EANT_TEST_TARGET="unittest"
src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar "build/lib/${PN}2-${PV}.jar"

	dodoc build/lib/*.properties
	dodoc ChangeLog README NEWS

	use doc && java-pkg_dojavadoc build/doc
	use source && java-pkg_dosrc src/*
}
