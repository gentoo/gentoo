# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="FastInfoset"

DESCRIPTION="Fast Infoset specifies a standardized binary encoding for the XML Information Sets"
HOMEPAGE="https://fi.java.net/"
SRC_URI="http://search.maven.org/remotecontent?filepath=com/sun/xml/${PN}/${MY_PN}/${PV}/${MY_PN}-${PV}-sources.jar"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

S="${WORKDIR}"
