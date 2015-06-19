# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/invokebinder/invokebinder-1.2.ebuild,v 1.4 2015/04/02 18:10:15 mr_bones_ Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Provide a friendly DSL for binding method handles"
SRC_URI="http://github.com/headius/invokebinder/archive/invokebinder-1.2.tar.gz"
HOMEPAGE="https://github.com/headius/invokebinder"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"

S="${WORKDIR}/${PN}-${P}"

DEPEND=">=virtual/jdk-1.7"
RDEPEND=">=virtual/jre-1.7"

# Tests fail, three similar errors where a string is inconvertible to int.
# Bug #472306.
RESTRICT="test"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar

	use source && java-pkg_dosrc src/main/java/com

	if use doc ; then
		java-pkg_dojavadoc target/site/apidocs

		dodoc README.markdown
	fi
}
