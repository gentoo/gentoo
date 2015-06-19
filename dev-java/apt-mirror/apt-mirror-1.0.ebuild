# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/apt-mirror/apt-mirror-1.0.ebuild,v 1.5 2008/05/11 13:40:55 maekke Exp $

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Annotation processing apt mirror API introduced in J2SE 5.0"
HOMEPAGE="http://aptmirrorapi.dev.java.net/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

S="${WORKDIR}/apt"

src_unpack() {

	unpack ${A}
	cp -i "${FILESDIR}/build.xml-${PV}" "${S}/build.xml" || die "cp failed"

}

src_install() {

	java-pkg_dojar "apt-mirror.jar"

	use source && java-pkg_dosrc .
	dodoc README.txt

}
