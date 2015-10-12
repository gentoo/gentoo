# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="Jama"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Java Matrix Package"
HOMEPAGE="http://math.nist.gov/javanumerics/jama/"
SRC_URI="http://math.nist.gov/javanumerics/${PN}/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}"
