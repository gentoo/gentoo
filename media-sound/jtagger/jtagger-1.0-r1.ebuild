# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="source test"

inherit eutils java-pkg-2

DESCRIPTION="Powerful MP3 tag and filename editor"
HOMEPAGE="http://dronten.googlepages.com/jtagger"
SRC_URI="http://dronten.googlepages.com/${PN}.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

COMMON_DEP="dev-java/jlayer:0
	>=dev-java/jid3-0.46-r1:0"

RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"

DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	app-arch/unzip:0"

S="${WORKDIR}"

java_prepare() {
	unzip -q ${PN}.jar || die

	# Fix for bug #231571 comment #2. This removes real @Override annotations but safer.
	sed -i -e "s/@Override//g" $(find . -name "*.java") || die "failed fixing for Java 5."

	rm -vr ${PN}.jar javazoom  org META-INF || die
	find . -name '*.class' -delete || die
}

src_compile() {
	local classpath="$(java-pkg_getjars jid3,jlayer)"

	find . -name '*.java' > sources.list
	ejavac -encoding latin1 -cp "${classpath}" @sources.list

	find . -name '*.class' -o -name '*.png' > classes.list
	touch myManifest
	jar cmf myManifest ${PN}.jar @classes.list || die "jar failed"
}

src_install() {
	java-pkg_dojar ${PN}.jar
	java-pkg_dolauncher jtagger --main com.googlepages.dronten.jtagger.JTagger

	use source && java-pkg_dosrc com

	newicon com/googlepages/dronten/jtagger/resource/jTagger.icon.png ${PN}.png
	make_desktop_entry jtagger "jTagger MP3 tag editor"
}
