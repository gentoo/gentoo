# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 java-pkg-simple

MY_PN="${PN}-api"
MY_PV="${PV}-MR1"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="JSR 181 API classes"
HOMEPAGE="http://jcp.org/en/jsr/summary?id=181"
SRC_URI="http://central.maven.org/maven2/javax/jws/${MY_PN}/${MY_PV}/${MY_P}-sources.jar"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip"
