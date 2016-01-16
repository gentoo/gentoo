# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java Swing layout manager that's powerful and easy to use"

HOMEPAGE="http://www.autel.cz/dmi/tutorial.html"
SRC_URI="http://www.autel.cz/dmi/HIGLayout${PV}.zip"
LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4
		app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}"

java_prepare() {
	cd tutorial || die
	for d in *.GIF;
	do
		mv $d $(basename $d .GIF).gif || die
	done
}

src_install() {
	java-pkg-simple_src_install
	if use examples; then
		dodir /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
