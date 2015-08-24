# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Java binding for libinklevel"
HOMEPAGE="https://mso.googlecode.com/"
SRC_URI="https://mso.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5
	>=net-print/libinklevel-0.8.0"

DEPEND=">=virtual/jdk-1.5
	>=net-print/libinklevel-0.8.0"

EANT_BUILD_TARGET="build"

src_install() {
	use source && java-pkg_dosrc src
	use doc && java-pkg_dojavadoc doc
	java-pkg_dojar build/${PN}.jar
	java-pkg_doso build/libjinklevel.so
	domo build/mo/*.mo || die "domo failed"
}
