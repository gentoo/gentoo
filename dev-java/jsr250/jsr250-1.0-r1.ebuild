# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JSR 250 Common Annotations"
HOMEPAGE="https://jcp.org/en/jsr/detail?id=250"
SRC_URI="http://download.java.net/maven/2/javax/annotation/${PN}-api/${PV}/${PN}-api-${PV}-sources.jar"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip"
