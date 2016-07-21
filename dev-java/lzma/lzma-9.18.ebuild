# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java code for LZMA compression and decompression"
HOMEPAGE="http://www.7-zip.org/"
SRC_URI="mirror://sourceforge/sevenzip/${PN}${PV/./}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"

S="${WORKDIR}/Java"

JAVA_SRC_DIR="SevenZip"
