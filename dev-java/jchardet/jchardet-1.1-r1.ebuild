# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java port of Mozilla's Automatic Charset Detection algorithm"
HOMEPAGE="http://jchardet.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${P}.zip"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip"

S="${WORKDIR}/${P}"
JAVA_SRC_DIR="src"

java_prepare() {
	java-pkg_clean
}
