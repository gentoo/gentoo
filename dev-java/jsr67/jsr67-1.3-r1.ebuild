# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

MY_PN="saaj-impl"
MY_P="${MY_PN}-${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="SAAJ 1.3 (AKA JSR-67 MR3) API"
HOMEPAGE="https://jcp.org/en/jsr/detail?id=67"
SRC_URI="https://repo1.maven.org/maven2/com/sun/xml/messaging/${MY_PN%%-*}/${MY_PN}/${PV}/${MY_P}-sources.jar -> ${P}.jar"

LICENSE="sun-jsr67"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	source? ( app-arch/zip )
	>=virtual/jdk-1.6"
