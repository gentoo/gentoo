# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Scripting for the Java(TM) Platform"
HOMEPAGE="http://jcp.org/en/jsr/detail?id=223"
SRC_URI="mirror://gentoo/${PN}-openjdk-6-src-b19.tar.bz2"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"
