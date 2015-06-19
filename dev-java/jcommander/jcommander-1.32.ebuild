# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jcommander/jcommander-1.32.ebuild,v 1.2 2013/11/25 18:46:54 ercpe Exp $

EAPI="5"

JAVA_PKG_IUSE="doc test"

inherit java-pkg-2 java-ant-2 vcs-snapshot

DESCRIPTION="Command line parsing framework for Java"
HOMEPAGE="https://github.com/cbeust/jcommander"
SRC_URI="https://github.com/cbeust/${PN}/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die
}

# Depends on itself through dev-java/testng (BGO) for building tests, bad idea.
RESTRICT="test"

# EANT_GENTOO_CLASSPATH_REWRITE="true"
# EANT_TEST_GENTOO_CLASSPATH="..."

src_test() {
	EANT_TEST_EXTRA_ARGS="-Djunit.present=true" java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${P}.jar

	dodoc README.markdown CHANGELOG
	use doc && java-pkg_dojavadoc target/site/apidocs
}
