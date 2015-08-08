# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Java code for LZMA compression and decompression"
HOMEPAGE="http://www.7-zip.org/"
SRC_URI="mirror://sourceforge/sevenzip/${PN}${PV/./}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"
S=${WORKDIR}/Java

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	cp "${FILESDIR}"/build.xml . || die
	#check for upstream adding build.xml, see Request ID 2464084 (on Feature
	#Request Tracer at http://sourceforge.net/projects/sevenzip/
}

src_install() {
	java-pkg_dojar ${PN}.jar
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc SevenZip
}
