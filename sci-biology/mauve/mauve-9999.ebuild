# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

ESVN_REPO_URI="https://mauve.svn.sourceforge.net/svnroot/mauve/mauve/trunk"

WANT_ANT_TASKS="ant-nodeps"
EANT_GENTOO_CLASSPATH="biojava,zeus-jscl,dbus-java"
JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_PKG_BSFIX_NAME="build.xml"

inherit subversion java-pkg-2 java-ant-2 eutils

DESCRIPTION="Multiple genome alignment with large-scale evolutionary events (GUI component)"
HOMEPAGE="http://gel.ahabs.wisc.edu/mauve/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
IUSE="doc"
KEYWORDS=""

CDEPEND="~sci-biology/biojava-1.6
	>=dev-java/dbus-java-2.5.1
	~dev-java/zeus-jscl-1.08
	dev-java/ant-nodeps"
RDEPEND=">=virtual/jre-1.5
	sci-biology/mauvealigner
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.5
	media-gfx/icoutils
	${CDEPEND}"

S="${WORKDIR}"

java_prepare() {
	find -name '*.jar' -not -name 'jarbundler*' -print -delete
	perl -i -ne 'print unless /<dmg/ or /<taskdef.+name="dmg"/../<\/taskdef>/' build.xml
	perl -i -ne 'print unless /<ssh/../<\/ssh/ or /<taskdef.+name="ssh"/../<\/taskdef>/' build.xml
	perl -i -ne 'print unless /<retroweaver/ or /<taskdef.+name="retroweaver"/../<\/taskdef>/' build.xml
}

src_install() {
	java-pkg_dojar Mauve.jar

	java-pkg_dolauncher Mauve --main org.gel.mauve.gui.Mauve

	icotool -x win32/mauve.ico
	insinto /usr/share/pixmaps
	newins mauve_4_48x48x32.png Mauve.png
	make_desktop_entry Mauve Mauve Mauve
}
