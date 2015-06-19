# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/flute/flute-1.3-r2.ebuild,v 1.3 2015/03/27 10:27:43 ago Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="sac"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Flute is an implementation for SAC"
HOMEPAGE="http://www.w3.org/Style/CSS/SAC/"
SRC_URI="http://www.w3.org/2002/06/flutejava-${PV}.zip"

LICENSE="W3C"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

COMMON_DEP="dev-java/sac"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}
	app-arch/unzip"

java_prepare() {
	rm -v flute.jar || die
	epatch "${FILESDIR}"/${PV}-rename-enum.patch
	cp "${FILESDIR}/build.xml" "${S}" || die
	mkdir src || die
	mv org src || die
}

EANT_DOC_TARGET=""

src_install() {
	java-pkg_dojar "${S}"/dist/flute.jar

	use doc && java-pkg_dojavadoc doc
	use source && java-pkg_dosrc "${S}"/src/*
}
