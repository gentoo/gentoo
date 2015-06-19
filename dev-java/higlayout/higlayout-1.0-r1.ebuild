# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/higlayout/higlayout-1.0-r1.ebuild,v 1.4 2007/10/27 14:01:14 angelos Exp $

inherit java-pkg-2

DESCRIPTION="Java Swing layout manager that's powerful and easy to use"

HOMEPAGE="http://www.autel.cz/dmi/tutorial.html"
SRC_URI="http://www.autel.cz/dmi/HIGLayout${PV}.zip"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc examples source"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	source? ( app-arch/zip )"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	mkdir classes api
	cd tutorial
	for d in *.GIF;
	do
		mv $d $(basename $d .GIF).gif
	done
}

src_compile() {
	ejavac -d classes src/cz/autel/dmi/*.java || die "failed to compile sources"
	jar -cf higlayout.jar -C classes cz || die "failed to create .jar"
	if use doc; then
		javadoc -author -version -d api src/cz/autel/dmi/*.java \
			|| die "javadoc failed"
	fi
}

src_install() {
	java-pkg_dojar ${PN}.jar
	dodoc *.txt
	if use doc; then
		dohtml -r tutorial
		java-pkg_dojavadoc api
	fi
	if use examples; then
		dodir /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
	use source && java-pkg_dosrc src/cz
}
