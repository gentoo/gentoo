# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/colt/colt-1.2.0-r1.ebuild,v 1.8 2014/08/10 20:09:32 slyfox Exp $

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="A set of Open Source Libraries for High Performance Scientific and Technical Computing in Java"
SRC_URI="http://dsd.lbl.gov/~hoschek/colt-download/releases/${P}.tar.gz"
HOMEPAGE="http://www-itg.lbl.gov/~hoschek/colt/"
LICENSE="colt"
IUSE=""
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

DEPEND=">=virtual/jdk-1.4
		>=dev-java/concurrent-util-1.3.4"
RDEPEND=">=virtual/jre-1.4
		 >=dev-java/concurrent-util-1.3.4"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-benchmark-no-deprecation.patch"

	find "${S}" -iname '*.jar' -exec rm \{\} \;

	cd "${S}/lib"
	java-pkg_jar-from concurrent-util
}

EANT_BUILD_TARGET="javac jar"

src_install() {
	java-pkg_dojar lib/${PN}.jar

	dohtml README.html || die
	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc src/*
}
