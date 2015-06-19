# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/stax-ex/stax-ex-1.7.6.ebuild,v 1.4 2015/04/10 22:43:25 chewi Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Extensions to complement JSR-173 StAX API"
HOMEPAGE="http://stax-ex.java.net/"
SRC_URI="https://maven.java.net/content/groups/public/org/jvnet/${PN/-/}/${PN}/${PV}/${P}-sources.jar"

LICENSE="CDDL GPL-2"
SLOT="1"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"

IUSE=""

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEPEND}"
