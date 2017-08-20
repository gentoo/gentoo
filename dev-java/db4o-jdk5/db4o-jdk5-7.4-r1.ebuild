# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Core files for the object database for Java"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${P}"

CDEPEND="
	dev-java/db4o-jdk11:0
	dev-java/db4o-jdk12:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

JAVA_GENTOO_CLASSPATH="db4o-jdk11 db4o-jdk12"

src_prepare() {
	default
	rm -rv "${S}/test" || die
}
