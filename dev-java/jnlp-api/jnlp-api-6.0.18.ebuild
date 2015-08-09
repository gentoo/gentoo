# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-pkg-simple

DESCRIPTION="JNLP API classes, repackaged from the icedtea-web fork of netx"
HOMEPAGE="http://jcp.org/en/jsr/detail?id=56"
SRC_URI="http://dev.gentoo.org/~caster/distfiles/${P}.tar.bz2"

LICENSE="GPL-2 GPL-2-with-linking-exception LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="source"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

src_install() {
	java-pkg_dojar ${PN}.jar
	use source && java-pkg_dosrc javax
}
