# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-pkg-simple versionator

DESCRIPTION="Sun J3D: 3D vector math package"
HOMEPAGE="https://vecmath.dev.java.net/"

MY_P="${PN}-$(replace_all_version_separators _ ${PV})"

SRC_URI="http://download.java.net/media/java3d/builds/release/${PV}/${MY_P}-src.zip"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-1"
IUSE=""
DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"
