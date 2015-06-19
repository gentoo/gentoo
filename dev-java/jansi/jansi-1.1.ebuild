# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jansi/jansi-1.1.ebuild,v 1.4 2011/08/13 07:07:41 xarthisius Exp $

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2

DESCRIPTION="Jansi is a small java library that allows you to use ANSI escape sequences in your console output"
HOMEPAGE="http://jansi.fusesource.org/"

SRC_URI="http://jansi.fusesource.org/repo/release/org/fusesource/jansi/jansi/${PV}/${P}-sources.jar"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND=">=virtual/jre-1.5
	dev-java/jna"

DEPEND=">=virtual/jdk-1.5
	dev-java/jna"

src_compile() {
	mkdir target
	ejavac -classpath "$(java-pkg_getjars jna)" org/fusesource/jansi/*.java org/fusesource/jansi/internal/*.java -d target
	jar -cf jansi.jar -C target .

	use doc && mkdir target/html && javadoc org/fusesource/jansi/*.java org/fusesource/jansi/internal/*.java -d target/html
}

src_install() {
	java-pkg_newjar "${PN}.jar"
	use doc && java-pkg_dojavadoc "target/html/"
	use source && java-pkg_dosrc "org"
}
