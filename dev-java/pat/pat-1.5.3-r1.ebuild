# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit versionator java-pkg-2 java-pkg-simple

MY_PV=$(delete_all_version_separators)
MAJORMINOR=$(get_version_component_range 1-2)
DOC_VER=$(delete_all_version_separators ${MAJORMINOR})
MY_P="${PN}-${PV}"

DESCRIPTION="Regular Expressions in Java"
HOMEPAGE="http://www.javaregex.com"
SRC_URI="http://www.javaregex.com/binaries/${PN}srcfree${MY_PV}.jar -> ${P}.jar"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	app-arch/unzip"
