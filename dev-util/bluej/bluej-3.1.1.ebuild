# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc examples source"
EANT_BUILD_TARGET="ready-to-run"
EANT_DOC_TARGET="doc-core"

inherit eutils java-pkg-2 java-ant-2

DOC_PV="2.0.1"

DESCRIPTION="An integrated Java environment for introductory teaching"
HOMEPAGE="http://bluej.org/"
SRC_URI="http://www.bluej.org/download/files/source/BlueJ-source-${PV//./}.zip
doc? ( http://bluej.org/download/files/${PN}-ref-manual.pdf
		http://bluej.org/tutorial/tutorial-${DOC_PV//.}.pdf -> ${PN}-tutorial-${DOC_PV}.pdf
		http://bluej.org/tutorial/testing-tutorial.pdf -> ${PN}-testing-tutorial.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=virtual/jdk-1.5.0"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

java_prepare() {
	sed -i \
		-e "s:^build_java_home=.*$:build_java_home=$(java-config -O):" \
		-e "/^bluej_home/d" \
		build.properties || die
}

src_install() {
	insinto /usr/share/${PN}
	doins -r lib icons

	# fix config location and set symlink
	dodir /etc
	mv "${D}"/{usr/share/${PN}/lib,etc}/${PN}.defs
	dosym /{etc,usr/share/${PN}/lib}/${PN}.defs

	use source && java-pkg_dosrc src/${PN}/*

	insinto /usr/share/doc/${PF}
	use examples && { doins -r examples
		docompress -x /usr/share/doc/${P}/examples ; }
	use doc && { doins "${DISTDIR}"/${PN}-*.pdf
		dohtml -r doc/all/* ; }

	newbin "${FILESDIR}"/${PN}.wrapper ${PN}

	make_desktop_entry ${PN} Blue-J
}
