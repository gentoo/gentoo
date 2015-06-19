# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/colt/colt-1.2.0-r2.ebuild,v 1.5 2015/05/27 11:27:37 ago Exp $

EAPI=5

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
		>=dev-java/concurrent-util-1.3.4:0"
RDEPEND=">=virtual/jre-1.4
		 >=dev-java/concurrent-util-1.3.4:0"

S="${WORKDIR}/${PN}"

EANT_BUILD_TARGET="javac jar"
JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="concurrent-util"

java_prepare() {
	find "${S}" -iname '*.jar' -delete || die

	epatch "${FILESDIR}/${P}-benchmark-no-deprecation.patch"
}

src_install() {
	java-pkg_dojar lib/${PN}.jar

	dohtml README.html || die
	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc src/*
}
