# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/args4j/args4j-2.32.ebuild,v 1.1 2015/06/12 14:57:37 monsieurp Exp $

EAPI=5

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="args4j is a Java command line arguments parser"
HOMEPAGE="http://args4j.kohsuke.org/"
SRC_URI="http://repo1.maven.org/maven2/${PN}/${PN}/${PV}/${P}-sources.jar"

LICENSE="CDDL"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip"
