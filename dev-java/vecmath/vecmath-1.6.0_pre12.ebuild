# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Sun J3D: 3D vector math package"
HOMEPAGE="https://vecmath.dev.java.net/"

MY_PV=$(replace_version_separator 3 '-')
SRC_URI="https://github.com/hharrison/vecmath/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="1.6"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=virtual/jdk-1.6
		dev-java/ant-core
		"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${PN}-${MY_PV}"

EANT_DOC_TARGET="docs"
EANT_BUILD_TARGET="jar"

src_install() {
	java-pkg_dojar "build/jars/${PN}.jar"

	use source && java-pkg_dosrc "${S}/src/*"

	dodoc *.txt docs/*.txt
	if use doc; then
		java-pkg_dojavadoc "build/javadoc/"
		dohtml -r *.html
	fi
}
