# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="API for textual pattern matching based on the finite state automaton theory"
HOMEPAGE="http://www.karneim.com/jrexx/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip -> ${P}.zip"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

JAVA_ENCODING="ISO-8859-1"
