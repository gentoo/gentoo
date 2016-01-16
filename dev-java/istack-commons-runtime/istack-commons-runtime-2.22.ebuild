# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 java-pkg-simple

MY_PN=${PN%%-*}

DESCRIPTION="IStack Commons - Runtime jar"
HOMEPAGE="https://istack-commons.java.net"
SRC_URI="https://maven.java.net/content/repositories/releases/com/sun/${MY_PN}/${PN}/${PV}/${P}-sources.jar"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip"
