# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Extensions to complement JSR-173 StAX API"
HOMEPAGE="http://stax-ex.dev.java.net/"
SRC_URI="https://stax-ex.dev.java.net/files/documents/4480/44372/${P}-src.tar.gz"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"

IUSE=""

COMMON_DEPEND="java-virtuals/jaf
	java-virtuals/stax-api"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEPEND}"

src_unpack() {

	unpack ${A}

	cd "${S}"
	# build.xml is from maven-1 and tries to download jars to /root/.maven/
	rm -f build.xml || die
	cp "${FILESDIR}/build.xml-${PV}" build.xml || die

	mkdir "${S}/lib" || die
	cd "${S}/lib"
	java-pkg_jar-from --virtual jaf
	java-pkg_jar-from --virtual stax-api

}

src_install() {

	java-pkg_dojar "stax-ex.jar"

	use source && java-pkg_dosrc src/java/*

}
