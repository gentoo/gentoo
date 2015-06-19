# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jid3/jid3-0.46-r1.ebuild,v 1.3 2008/06/12 18:35:32 opfer Exp $

JAVA_PKG_IUSE="doc source test"
# To make sure the javadoc patch doesn't break things
WANT_SPLIT_WANT="true"

inherit eutils java-pkg-2 java-ant-2

MY_P=${P/-/_}
S=${WORKDIR}/${MY_P}

DESCRIPTION="ID3 Class Library Implementation"
HOMEPAGE="http://jid3.blinkenlights.org/"
SRC_URI="http://jid3.blinkenlights.org/release/${MY_P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# Feel free to submit a patch that doesn't bundle the classes
# into the result jar
RDEPEND=">=virtual/jre-1.4
	test? ( =dev-java/junit-3.8* )"

DEPEND=">=virtual/jdk-1.4
	test? ( =dev-java/junit-3.8* )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PV}-javadoc.patch"
	epatch "${FILESDIR}/${PV}-tests-and-unicode.patch"
	rm -v "${S}"/dist/*.jar || die
	if use !test; then
		rm -rv "${S}/src/org/blinkenlights/jid3/test" || die
	fi

}

src_compile() {
	local junit="-Dlibs.junit.classpath"
	eant jar $(use_doc) \
		$(use test && echo ${junit}=$(java-pkg_getjars junit))
}

src_test() {
	ejunit -cp dist/JID3.jar org.blinkenlights.jid3.test.AllTests
}

src_install() {
	java-pkg_dojar dist/JID3.jar
	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src/
}
