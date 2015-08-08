# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Re-implementation of Franklin Mark Liang's hyphenation algorithm in Java"
HOMEPAGE="http://www.davidashen.net/texhyphj.html http://sourceforge.net/projects/texhyphj/"
SRC_URI="http://ftp.davidashen.net/TeXHyphenator-J/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RESTRICT="test"

DEPEND="app-arch/unzip
	>=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${PN}"
