# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/fastinfoset/fastinfoset-1.2.11.ebuild,v 1.4 2015/04/21 18:35:51 pacho Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="FastInfoset"

DESCRIPTION="Fast Infoset specifies a standardized binary encoding for the XML Information Sets"
HOMEPAGE="https://fi.java.net/"
SRC_URI="http://search.maven.org/remotecontent?filepath=com/sun/xml/${PN}/${MY_PN}/${PV}/${MY_PN}-${PV}-sources.jar"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

S="${WORKDIR}"
