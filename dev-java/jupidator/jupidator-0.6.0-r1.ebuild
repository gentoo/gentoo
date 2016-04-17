# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_P="${PN}.${PV}"

DESCRIPTION="Jupidator is a library/tool in Java for automatic updating of applications"
HOMEPAGE="http://www.sourceforge.net/projects/jupidator"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

S="${WORKDIR}/${PN}"

JAVA_SRC_DIR="src"

java_prepare() {
	java-pkg_clean
}
