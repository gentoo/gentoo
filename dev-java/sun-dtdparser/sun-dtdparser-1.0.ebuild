# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Sun DTDParser"
HOMEPAGE="https://jaxb2-sources.dev.java.net/"
# Downloadable from https://jaxb2-sources.dev.java.net/
SRC_URI="mirror://gentoo/dtd-parser-${PV}-src.zip"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"

IUSE=""

COMMON_DEP=""

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}/dtd-parser-${PV}"

src_install() {
	java-pkg_newjar "${S}/target/dtd-parser-1.0.jar"
	use source && java-pkg_dosrc src/*
	use doc && java-pkg_dojavadoc dist/docs/api
}
