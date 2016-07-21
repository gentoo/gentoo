# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java Evolutionary Biology Library"
HOMEPAGE="http://jebl.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="LGPL-2.1"
IUSE=""

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

EANT_BUILD_TARGET="dist"
EANT_DOC_TARGET="document"

java_prepare() {
	rm -rf "${S}/src/org/virion/jam/maconly" || die
}

src_install() {
	java-pkg_dojar dist/jebl.jar || die
	java-pkg_dojar dist/jam.jar || die
	use doc && java-pkg_dojavadoc doc/api
}
