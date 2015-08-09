# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

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

src_unpack() {
	unpack ${A}

	cp "${FILESDIR}/build.xml" "${S}"

	cd "${S}"
	rm -v flute.jar || die

	mkdir src
	mv org src
	echo "classpath=$(java-pkg_getjars sac)" > "${S}"/build.properties
}

EANT_DOC_TARGET=""

src_install() {
	java-pkg_dojar "${S}"/dist/flute.jar

	use doc && java-pkg_dojavadoc doc
	use source && java-pkg_dosrc "${S}"/src/*
}
