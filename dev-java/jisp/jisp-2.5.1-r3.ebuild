# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple eutils

DESCRIPTION="Java Indexed Serialization Package: A small, embedded database engine written in Pure Java"
HOMEPAGE="http://www.coyotegulch.com/products/jisp/"

# TODO contact upstream about hosting jisp-2.5 on their site.
# They only maintain 3.0 at the moment
# This tarball is from jpackage's jisp2 source rpm
SRC_URI="http://gentooexperimental.org/distfiles/${P}-source.tar.gz"

LICENSE="SVFL"
SLOT="2.5"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src"

java_prepare() {
	epatch "${FILESDIR}"/${P}-java15.patch

	mkdir src || die
	mv com src || die
}
