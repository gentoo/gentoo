# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Glassfish implementation of persistence API"
HOMEPAGE="https://glassfish.java.net/"
SRC_URI="http://download.java.net/javaee5/fcs_branch/promoted/source/glassfish-9_0-b48-src.zip"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	>=virtual/jre-1.5"
DEPEND="
	>=virtual/jdk-1.5
	app-arch/unzip"

S="${WORKDIR}/glassfish"

java_prepare() {
	epatch "${FILESDIR}"/${P}-python2.7-sax-parser.patch #414807
}

EANT_BUILD_XML="persistence-api/build.xml"
EANT_BUILD_TARGET="all"

src_install() {
	cd "${WORKDIR}"/publish/glassfish || die
	java-pkg_newjar lib/javaee.jar

	insinto /usr/share/${PN}/lib/schemas
	doins lib/schemas/*.xsd
}
