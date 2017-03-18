# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java XPath API"
HOMEPAGE="https://saxpath.sourceforge.net"
SRC_URI="https://repo1.maven.org/maven2/${PN}/${PN}/${PV}-FCS/${P}-FCS-sources.jar -> ${P}.jar"

LICENSE="JDOM"
SLOT="0"
KEYWORDS="amd64 ~arm ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"
