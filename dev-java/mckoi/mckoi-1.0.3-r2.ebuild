# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/mckoi/mckoi-1.0.3-r2.ebuild,v 1.2 2009/12/10 19:59:32 maekke Exp $

EAPI=2
JAVA_PKG_IUSE="doc examples source"
JAVA_PKG_WANT_BOOTCLASSPATH="1.5"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Mckoi Java SQL Database System"
HOMEPAGE="http://mckoi.com/database/"
SRC_URI="http://www.mckoi.com/database/ver/${P/-/}.zip"
LICENSE="GPL-2"
SLOT="1"
KEYWORDS="amd64 x86"
IUSE=""
COMMON_DEP="=dev-java/gnu-regexp-1.1*"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}/${P/-/}"

# uses enum as identifier
JAVA_PKG_WANT_SOURCE="1.4"
JAVA_PKG_WANT_TARGET="1.4"

src_unpack() {
	default
	cd "${S}"
	unpack ./src.zip
}

java_prepare() {
	epatch "${FILESDIR}/${P}-jikes.patch"

	cp "${FILESDIR}/build.xml" . || die
	java-ant_rewrite-classpath
	java-ant_rewrite-bootclasspath 1.5

	rm -v gnu-regexp-*
	rm -v *.jar
	find demo -name '*.class' -delete
	# some contrib stuff depending on jboss
	rm -rf src/net
}

EANT_DOC_TARGET="docs"
EANT_GENTOO_CLASSPATH="gnu-regexp-1"

src_install() {
	java-pkg_dojar dist/mckoidb.jar

	dodoc README.txt db.conf

	# apidocs are in expected place
	use doc && java-pkg_dohtml -r docs/*
	use examples && java-pkg_doexamples demo
	use source && java-pkg_dosrc src/*
}
