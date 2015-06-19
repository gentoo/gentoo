# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jdynamite/jdynamite-1.2.ebuild,v 1.8 2013/05/10 09:37:31 tomwij Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_PV="${PV/./_}"
DESCRIPTION="Dynamic Template in Java"
HOMEPAGE="http://jdynamite.sourceforge.net/doc/jdynamite.html"
SRC_URI="mirror://sourceforge/${PN}/${PN}${MY_PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND=">=virtual/jdk-1.2
	dev-java/gnu-regexp:1"
RDEPEND=">=virtual/jre-1.2"

S="${WORKDIR}/${PN}${PV}"

# Do not generate docs that don't exist, use bundled.
EANT_DOC_TARGET=""

java_prepare() {
	# Yuck! Already compiled!
	cd "${S}"
	rm -fr lib/*
	rm -fr cb
	rm -fr src/gnu

	cp "${FILESDIR}/${PV}-build.xml" build.xml || die
	mkdir build || die
}

src_compile() {
	EANT_EXTRA_ARGS="-Dgentoo.classpath=$(java-pkg_getjar --build-only gnu-regexp-1 gnu-regexp.jar)"

	java-pkg-2_src_compile
}

src_install() {
	java-pkg_dojar ${PN}.jar

	if use doc; then
		java-pkg_dohtml -r doc/*
	fi

	use source && java-pkg_dosrc src/cb
}
