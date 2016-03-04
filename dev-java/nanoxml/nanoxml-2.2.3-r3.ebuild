# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

MY_P="NanoXML-${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="NanoXML is a small non-validating parser for Java"
HOMEPAGE="http://nanoxml.sourceforge.net/"
SRC_URI="http://pkgs.fedoraproject.org/repo/pkgs/nanoxml/${MY_P}.tar.gz/357c7136417ea996cf714278ea84f2df/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

CDEPEND="dev-java/sax:0"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

S="${WORKDIR}/${MY_P}"

JAVA_GENTOO_CLASSPATH="sax"

JAVA_SRC_DIR="Sources"

PATCHES=(
	"${FILESDIR}"/"${P}-lite-enum.patch"
	"${FILESDIR}"/"${P}-enum.patch"
)

java_prepare() {
	java-pkg_clean
	rm -rf Test || die
	epatch "${PATCHES[@]}"
}
