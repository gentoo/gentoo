# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jmx/sun-jmx-1.2.1-r3.ebuild,v 1.14 2014/08/10 20:25:09 slyfox Exp $

EAPI=4

JAVA_PKG_IUSE="doc examples"

inherit java-pkg-2

MY_P=jmx-${PV//./_}
DESCRIPTION="Java Management Extensions for managing and monitoring devices, applications, and services"
HOMEPAGE="http://www.oracle.com/technetwork/java/javase/tech/javamanagement-140525.html"
SRC_URI="${MY_P}-ri.zip"

LICENSE="Oracle-BCLA-JavaSE"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"
RESTRICT="fetch"

S="${WORKDIR}/${MY_P}-bin"

DOWNLOADSITE="http://www.oracle.com/technetwork/java/javasebusiness/downloads/java-archive-downloads-java-plat-419418.html"

src_compile() { :; }

pkg_nofetch() {
	einfo
	einfo " Due to license restrictions, we cannot fetch the"
	einfo " distributables automagically."
	einfo
	einfo " 1. Visit ${DOWNLOADSITE} and follow instructions"
	einfo " 2. Download ${SRC_URI}"
	einfo " 3. Move file to ${DISTDIR}"
	einfo " 4. Run emerge on this package again to complete"
	einfo
}

src_install() {
	java-pkg_dojar lib/*.jar
	if use doc; then
		java-pkg_dojavadoc doc/api
		java-pkg_dohtml -r doc/doc doc/index.html
	fi
	use examples && java-pkg_doexamples examples
}
