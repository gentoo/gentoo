# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/relaxng-datatype/relaxng-datatype-1.0-r1.ebuild,v 1.18 2013/06/27 21:17:52 aballier Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils

MY_PN="relaxngDatatype"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Interface between RELAX NG validators and datatype libraries"
HOMEPAGE="http://relaxng.org/"
SRC_URI="mirror://sourceforge/relaxng/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc source"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -v *.jar || die
	epatch "${FILESDIR}/${P}-build_xml.patch"
}

src_install() {
	java-pkg_dojar ${MY_PN}.jar
	dodoc README.txt || die

	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc src/*
}
