# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Java library to detect printers"
HOMEPAGE="http://mso.googlecode.com/"
SRC_URI="http://mso.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5
	sys-apps/hwinfo
	dev-java/jinklevel:0"

DEPEND=">=virtual/jdk-1.5
	sys-apps/hwinfo
	dev-java/jinklevel:0"

EANT_BUILD_TARGET="build"
EANT_GENTOO_CLASSPATH="jinklevel"
JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_CLASSPATH_TAGS+=" javadoc"

src_install() {
	use source && java-pkg_dosrc src
	use doc && java-pkg_dojavadoc doc
	java-pkg_dojar build/${PN}.jar
	java-pkg_doso build/${PN}.so
}
