# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/rhino/rhino-1.7.2-r2.ebuild,v 1.12 2015/06/11 10:55:06 chewi Exp $

EAPI="1"
JAVA_PKG_IUSE="doc examples source"
inherit java-pkg-2 java-ant-2 eutils versionator

MY_P="${PN}$(replace_version_separator 1 _ $(replace_version_separator 2 R))"

DESCRIPTION="An open-source implementation of JavaScript written in Java"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla.org/js/${MY_P}.zip
	mirror://gentoo/rhino-swing-ex-1.0.zip"
HOMEPAGE="http://www.mozilla.org/rhino/"
# dual license for rhino and BSD-2 for the swing-ex from Sun's tutorial
LICENSE="|| ( MPL-1.1 GPL-2 ) BSD-2"
SLOT="1.6"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

S="${WORKDIR}/${MY_P}"

CDEPEND="=dev-java/xml-xmlbeans-1*"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${CDEPEND}"

src_unpack() {
	unpack ${MY_P}.zip
	cd "${S}"

	# don't download src.zip from Sun
	epatch "${FILESDIR}/rhino-1.6-noget.patch"

	rm -v *.jar || die
	rm -rf docs/apidocs || die

	local dir="toolsrc/org/mozilla/javascript/tools/debugger/downloaded"
	mkdir ${dir} || die
	cp "${DISTDIR}/rhino-swing-ex-1.0.zip" ${dir}/swingExSrc.zip || die

	mkdir lib/ && cd lib/ || die
	java-pkg_jar-from xml-xmlbeans-1 xbean.jar

	# Stop downloading of deps
	cd "${S}"
	mkdir -p build/tmp-xbean
	touch build/tmp-xbean/xbean.zip
	touch lib/jsr173_1.0_api.jar
}

src_install() {
	java-pkg_dojar build/${MY_P}/js.jar

	java-pkg_dolauncher jsscript-${SLOT} \
		--main org.mozilla.javascript.tools.shell.Main

	use doc && java-pkg_dojavadoc "build/${MY_P}/javadoc"
	use examples && java-pkg_doexamples examples
	use source && java-pkg_dosrc {src,toolsrc,xmlimplsrc}/org
}
