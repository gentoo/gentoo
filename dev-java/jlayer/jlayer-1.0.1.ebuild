# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="MP3 decoder/player/converter library for Java"
HOMEPAGE="http://www.javazoom.net/javalayer/javalayer.html"

SRC_URI="http://www.javazoom.net/javalayer/sources/${PN}${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${RDEPEND}"

S=${WORKDIR}/JLayer${PV}
EANT_BUILD_TARGET="dist"
EANT_DOC_TARGET="all"

src_prepare() {
	rm -v *.jar || die
	# build expects classes to exist
	rm -vr classes/* || die
}

src_install(){
	java-pkg_newjar jl${PV}.jar
	dodoc README.txt CHANGES.txt || die
	dohtml playerapplet.html || die
	use doc && java-pkg_dojavadoc doc
	use source && java-pkg_dosrc src/*

	# the MP3TOWAV converter
	java-pkg_dolauncher jl-converter \
		--main javazoom.jl.converter.jlc

	# the simple MP3 player
	java-pkg_dolauncher jl-player \
		--main javazoom.jl.player.jlp

	# the advanced (threaded) MP3 player
	java-pkg_dolauncher jl-advanced-player \
		--main javazoom.jl.player.advanced.jlap
}
