# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/joda-time/joda-time-1.6.ebuild,v 1.7 2014/08/10 20:19:22 slyfox Exp $

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

MY_P="${P}-src"

DESCRIPTION="A quality open-source replacement for the Java Date and Time classes"
HOMEPAGE="http://joda-time.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND="
	>=virtual/jdk-1.4
	test? ( dev-java/ant-junit )"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -v *.jar || die
	# https://sourceforge.net/tracker/index.php?func=detail&aid=1855430&group_id=97367&atid=617889
	epatch "${FILESDIR}/1.5.1-ecj.patch"
}

# chokes on static inner class making instance of non-static inner class
EANT_FILTER_COMPILER="jikes"
# little trick so it doesn't try to download junit
EANT_EXTRA_ARGS="-Djunit.ant=1 -Djunit.present=1"

src_test() {
	ANT_TASKS="ant-junit" eant -Djunit.jar="$(java-pkg_getjars junit)" test
}

src_install() {
	java-pkg_newjar build/${P}.jar

	dodoc LICENSE.txt NOTICE.txt RELEASE-NOTES.txt ToDo.txt || die
	use doc && java-pkg_dojavadoc build/docs
	use examples && java-pkg_doexamples src/example
	use source && java-pkg_dosrc src/java/org
}
