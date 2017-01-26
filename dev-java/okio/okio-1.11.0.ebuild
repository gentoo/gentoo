# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_P="${PN}-parent-${PV}"

DESCRIPTION="A modern I/O API for Java"
HOMEPAGE="https://github.com/square/okio"
SRC_URI="https://github.com/square/${PN}/archive/${MY_P}.zip -> ${P}.zip"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=virtual/jre-1.7"

CDEPEND="
	source? ( app-arch/zip )
	dev-java/jmh-core:0
	dev-java/junit:4"

DEPEND=">=virtual/jdk-1.7
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.7
	${CDEPEND}"

S="${WORKDIR}/${PN}-${MY_P}"

JAVA_GENTOO_CLASSPATH="jmh-core,junit-4"

src_prepare(){
	epatch "${FILESDIR}/okio-remove-maven-animal-jre.patch"
}
