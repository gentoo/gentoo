# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="SAC is a standard interface for CSS parser"
HOMEPAGE="http://www.w3.org/Style/CSS/SAC/"
SRC_URI="http://www.w3.org/2002/06/sacjava-${PV}.zip"

LICENSE="W3C"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

src_unpack() {
	unpack ${A}

	cp "${FILESDIR}/build.xml" "${S}"

	cd "${S}"
	rm -rv sac.jar META-INF/ || die

	mkdir src
	mv org src
}

EANT_DOC_TARGET=""

src_install() {
	java-pkg_dojar dist/sac.jar

	use doc && java-pkg_dojavadoc doc
	use source && java-pkg_dosrc src/*
}
