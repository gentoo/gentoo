# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

MY_PN="looks"
MY_PV="${PV//./_}"
MY_P="${MY_PN}-${MY_PV}"
DESCRIPTION="JGoodies Looks Library"
HOMEPAGE="http://www.jgoodies.com/"
SRC_URI="http://www.jgoodies.com/download/libraries/${MY_PN}/${MY_P}.zip"

LICENSE="BSD"
SLOT="2.0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${MY_PN}-${PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# remove the bootclasspath brokedness, make building demo optional
	epatch "${FILESDIR}/${PN}-2.0.4-build.xml.patch"

	# unzip the look&feel settings from bundled jar before we delete it
	unzip -j looks-${PV}.jar META-INF/services/javax.swing.LookAndFeel \
		|| die "unzip of javax.swing.LookAndFeel failed"
	# and rename it to what build.xml expects
	mv javax.swing.LookAndFeel all.txt

	rm -v *.jar demo/*.jar lib/*.jar || die
	rm -rv docs/api || die
}

src_compile() {
	# bug #150970
	java-pkg_filter-compiler jikes

	# jar target fails unless we make descriptors.dir an existing directory
	# I checked the ustream binary distribution and they also don't actually
	# put anything there.
	# 31.7.2006 betelgeuse@gentoo.org
	# update: it's where it looks for all.txt file
	# 16.1.2007 caster@gentoo.org
	eant -Ddescriptors.dir="${S}" jar-all $(use_doc)
}

src_install() {
	java-pkg_dojar build/looks.jar

	dodoc RELEASE-NOTES.txt || die
	dohtml README.html || die
	if use doc; then
		java-pkg_dohtml -r docs/*
		java-pkg_dojavadoc build/docs/api
	fi
	use source && java-pkg_dosrc src/core/com
}
