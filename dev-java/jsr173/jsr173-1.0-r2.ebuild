# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Library for parsing and writing XML"
HOMEPAGE="http://dev2dev.bea.com/xml/stax.html"
SRC_URI="http://ftpna2.bea.com/pub/downloads/${PN}.jar"

LICENSE="bea.ri.jsr173"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

CDEPEND="dev-java/jaxme:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

S="${WORKDIR}"

src_unpack() {
	cd "${S}" || die

	jar xvf "${DISTDIR}/${A}" || die "failed to unpack"
	jar xvf ${P//-/_}_src.jar || die "failed to unpack"
}

src_prepare() {
	default

	cd "${S}" || die
	java-pkg_clean
	cp "${FILESDIR}/${P}-build.xml" build.xml || die
	java-pkg_jarfrom jaxme
}

src_compile() {
	local antflags="-Dproject.name=${PN} jar"
	eant ${antflags} "$(use_doc)"
}

src_install() {
	java-pkg_dojar "dist/${PN}.jar"

	use doc && java-pkg_dojavadoc dist/doc/api
	use source && java-pkg_dosrc src/*
}
