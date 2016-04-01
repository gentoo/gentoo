# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An improved version of JToolBar"
HOMEPAGE="http://toolbar.tigris.org"
SRC_URI="http://toolbar.tigris.org/files/documents/869/25285/toolbar-${PV}-src.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

JAVA_SRC_DIR="src"

java_prepare() {
	rm -rv test || die
}
