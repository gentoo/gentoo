# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XML Im-/Exporter is a library to assist im/export XML"
HOMEPAGE="http://xml-im-exporter.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}${PV}.tgz -> ${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	source? ( app-arch/zip )
	>=virtual/jdk-1.6"

S="${WORKDIR}/${PN}"

JAVA_ENCODING="ISO-8859-1"

JAVA_SRC_DIR="src"

java_prepare() {
	java-pkg_clean
	rm -rf src/test || die
}

src_install() {
	java-pkg-simple_src_install
	dodoc Changes.txt Open-Issues.txt Readme.txt Version.txt
}
