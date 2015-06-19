# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jmdns/jmdns-1.0.ebuild,v 1.6 2014/08/10 20:18:21 slyfox Exp $

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2

DESCRIPTION="JmDNS is an implementation of multi-cast DNS in Java"
SRC_URI="mirror://sourceforge/${PN}/${P}-Final.tar.gz"
HOMEPAGE="http://jmdns.sourceforge.net"
IUSE=""
DEPEND=">=virtual/jdk-1.3.1"
RDEPEND=">=virtual/jre-1.3.1"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm lib/*.jar
}

src_compile() {
	echo "Compiling JmDNS..."
	ejavac "${S}"/src/javax/jmdns/* || die
	echo "Compiling tools..."
	ejavac -classpath "${S}/src" "${S}"/src/com/strangeberry/jmdns/tools/* || die
	echo "Making jars..."
	echo "Main-class: com.strangeberry.jmdns.tools.Main" > jmdns-tools-manifest
	jar cmf jmdns-tools-manifest jmdns.jar -C "${S}/src" com -C "${S}/src" javax || die
}

src_install() {
	java-pkg_dojar jmdns*.jar
	java-pkg_dolauncher
	dodoc README.txt CHANGELOG.txt

	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src/{com,javax}

	if use examples; then
		insinto /usr/share/doc/${P}/
		doins -r src/samples
	fi
}
