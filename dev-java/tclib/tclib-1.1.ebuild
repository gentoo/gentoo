# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/tclib/tclib-1.1.ebuild,v 1.3 2012/03/15 14:35:09 sera Exp $

EAPI="2"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Type-Specific Collections Library"
HOMEPAGE="http://www.sosnoski.com/opensrc/tclib/"
SRC_URI="mirror://gentoo/${P}-source.jar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"

S="${WORKDIR}"

java_prepare() {
	find -name '*.jar' -print -delete
	find -name '*.class' -print -delete
}

EANT_BUILD_XML="build/build.xml"
EANT_BUILD_TARGET="package"

src_install() {
	java-pkg_dojar lib/tclib.jar
	use source && java-pkg_dosrc build/src
	use doc && java-pkg_dojavadoc build/docs
}
