# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java port of Mozilla's Automatic Charset Detection algorithm"
HOMEPAGE="http://jchardet.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${P}.zip"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

EANT_BUILD_TARGET="dist"

src_prepare() {
	rm -f dist/lib/chardet.jar

	mkdir -p src/org/mozilla/intl/chardet/ || die
	mv src/*.java src/org/mozilla/intl/chardet || die
}

src_install() {
	java-pkg_dojar dist/lib/chardet.jar

	use source && java-pkg_dosrc src/*
}
