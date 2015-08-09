# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

JAVA_PKG_IUSE="source"
WANT_ANT_TASKS="ant-nodeps"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="GMSO 2 queries ink levels of libinklevel supported printers"
HOMEPAGE="http://mso.googlecode.com/"
SRC_URI="http://mso.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEP="
	dev-java/libmso:0
	dev-java/jinklevel:0
	>=dev-java/java-gnome-4.0.15:4.0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5
	x11-libs/gksu"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5"

EANT_BUILD_TARGET="build"
EANT_GENTOO_CLASSPATH="jinklevel,libmso,java-gnome-4.0"
JAVA_ANT_REWRITE_CLASSPATH="true"

src_install() {
	use source && java-pkg_dosrc src
	java-pkg_dojar build/${PN}.jar
	domo build/mo/*.mo || die "domo failed"
	doicon image/* || die "doicon failed"
	java-pkg_dolauncher ${PN} --main com.googlecode.mso.gmso2.Gmso2
	make_desktop_entry "gksu -u root ${PN}" "GMSO 2" gmso2_icon "Printing;;"
}
