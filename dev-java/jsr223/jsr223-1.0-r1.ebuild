# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jsr223/jsr223-1.0-r1.ebuild,v 1.4 2010/06/24 21:07:43 pacho Exp $

EAPI="2"
JAVA_PKG_IUSE=""

inherit java-pkg-2

DESCRIPTION="Scripting for the Java(TM) Platform"
HOMEPAGE="http://jcp.org/en/jsr/detail?id=223"

# http://download.java.net/openjdk/jdk6/promoted/b19/openjdk-6-src-b19-15_apr_2010.tar.gz
# tar xvf openjdk-6-src-b19-15_apr_2010.tar.gz jdk/src/share/classes/javax/script
# tar cjvf jsr223-openjdk-6-src-b19.tar.bz2 jdk/
SRC_URI="mirror://gentoo/jsr223-openjdk-6-src-b19.tar.bz2"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

S="${WORKDIR}"

src_compile() {
	mkdir build || die
	ejavac -d build jdk/src/share/classes/javax/script/*.java
	jar -cf script-api.jar -C build javax || die
}

src_install() {
	java-pkg_dojar script-api.jar
}
