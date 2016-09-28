# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Professional cross platform layouts with Swing"
HOMEPAGE="https://swing-layout.dev.java.net/"
SRC_URI="mirror://gentoo/${P}-src.zip"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="doc source"

DEPEND="
	>=virtual/jdk-1.6"

RDEPEND="
	>=virtual/jre-1.6"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src"

src_prepare() {
	default
}
