# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/poxml/poxml-4.14.3.ebuild,v 1.1 2015/06/04 18:44:48 kensington Exp $

EAPI=5

JAVA_PKG_OPT_USE=extras
inherit java-pkg-opt-2 java-ant-2 kde4-base

DESCRIPTION="KDE utility to translate DocBook XML files using gettext po files"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug extras"

DEPEND="
	extras? (
		>=virtual/jdk-1.5
		>=dev-java/antlr-2.7.7:0[cxx,java,script]
	)
"
RDEPEND="
	extras? (
		>=virtual/jre-1.5
		>=dev-java/antlr-2.7.7:0[cxx,java,script]
	)
	!<=kde-base/kdesdk-misc-4.10.50:4
"

# java deps on anltr cant be properly explained to cmake deps
# needs to be run in one thread
MAKEOPTS+=" -j1"

pkg_setup() {
	kde4-base_pkg_setup
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	kde4-base_src_prepare
	java-pkg-opt-2_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with extras Antlr2)
	)

	kde4-base_src_configure
	java-ant-2_src_configure
}

pkg_preinst() {
	kde4-base_pkg_preinst
	java-pkg-2_pkg_preinst
}
