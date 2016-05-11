# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Portlet API implementation of JSR 168"
HOMEPAGE="http://portals.apache.org/jetspeed-2/"
SRC_URI="https://dev.gentoo.org/~monsieurp/packages/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="amd64 ppc64 x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6"
