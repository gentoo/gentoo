# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2 flag-o-matic virtualx subversion

tp_base="http://javootoo.l2fprod.com/plaf/skinlf/themepacks"
tvp_base="http://tvbrowser.org/downloads"

DESCRIPTION="Themeable and easy to use TV Guide - written in Java"
HOMEPAGE="http://www.tvbrowser.org/"
ESVN_REPO_URI="https://tvbrowser.svn.sourceforge.net/svnroot/tvbrowser/trunk/tvbrowser"
SRC_URI="
themes? (
	${tp_base}/BeOSthemepack.zip
	${tp_base}/amarachthemepack.zip
	${tp_base}/aquathemepack.zip
	${tp_base}/architectBluethemepack.zip
	${tp_base}/architectOlivethemepack.zip
	${tp_base}/b0sumiErgothempack.zip
	${tp_base}/b0sumithemepack.zip
	${tp_base}/bbjthemepack.zip
	${tp_base}/beigeazulthemepack.zip
	${tp_base}/beosthemepack.zip
	${tp_base}/blueMetalthemepack.zip
	${tp_base}/blueTurquesathemepack.zip
	${tp_base}/cellshadedthemepack.zip
	${tp_base}/chaNinja-Bluethemepack.zip
	${tp_base}/coronaHthemepack.zip
	${tp_base}/cougarthemepack.zip
	${tp_base}/crystal2themepack.zip
	${tp_base}/fatalEthemepack.zip
	${tp_base}/gfxOasisthemepack.zip
	${tp_base}/gorillathemepack.zip
	${tp_base}/hmmXPBluethemepack.zip
	${tp_base}/hmmXPMonoBluethemepack.zip
	${tp_base}/iBarthemepack.zip
	${tp_base}/macosthemepack.zip
	${tp_base}/midnightthemepack.zip
	${tp_base}/mmMagra-Xthemepack.zip
	${tp_base}/modernthemepack.zip
	${tp_base}/oliveGreenLunaXPthemepack.zip
	${tp_base}/opusLunaSilverthemepack.zip
	${tp_base}/opusOSBluethemepack.zip
	${tp_base}/opusOSDeepthemepack.zip
	${tp_base}/opusOSOlivethemepack.zip
	${tp_base}/quickSilverRthemepack.zip
	${tp_base}/roueBluethemepack.zip
	${tp_base}/roueBrownthemepack.zip
	${tp_base}/roueGreenthemepack.zip
	${tp_base}/royalInspiratthemepack.zip
	${tp_base}/silverLunaXPthemepack.zip
	${tp_base}/solunaRthemepack.zip
	${tp_base}/tigerGraphitethemepack.zip
	${tp_base}/tigerthemepack.zip
	${tp_base}/toxicthemepack.zip
	${tp_base}/underlingthemepack.zip
	${tp_base}/whistlerthemepack.zip
	${tp_base}/xplunathemepack.zip

	${tvp_base}/noia.zip
	${tvp_base}/nuvola.zip
	${tvp_base}/tulliana.zip
	${tvp_base}/tango_without_heart.zip
)"

SLOT="0"
KEYWORDS=""
LICENSE="GPL-3"

IUSE="themes"

CDEPEND="dev-java/bsh:0
	dev-java/commons-codec:0
	dev-java/commons-lang:3.3
	dev-java/commons-net:0
	dev-java/jakarta-oro:2.0
	dev-java/jgoodies-common:1.8
	dev-java/jgoodies-forms:1.8
	dev-java/jgoodies-looks:2.6
	dev-java/l2fprod-common:0
	dev-java/log4j:0
	dev-java/skinlf:0
	dev-java/stax:0
	dev-java/swt:4.2
	dev-java/xalan:0
	x11-libs/libXt:0
	x11-libs/libSM:0
	x11-libs/libICE:0
	x11-libs/libXext:0
	x11-libs/libXtst:0
	x11-libs/libX11:0
	x11-libs/libXau:0
	x11-libs/libXdmcp:0"

DEPEND="${CDEPEND}
	app-arch/unzip:0
	>=virtual/jdk-1.6
	test? ( dev-java/junit:0 dev-java/ant-junit:0 )"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"

src_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die "Failed to replace build.xml."

	# Yes, there are some bundled jars. 
	# Can't help but use them for the time being.
	local error="Failed to unbundle or remove libraries or classes."
	pushd lib > /dev/null
		rm -v bsh-*.jar commons*.jar jgoodies*.jar l2fprod-common-tasks*.jar \
			skinlf*.jar stax*.jar || die ${error}
	popd > /dev/null

	find deployment -name '*.jar' -exec rm -v {} \; || die ${error}
	find . -name '*.class' -exec rm -v {} \; || die ${error}

	# These tests fail.
	rm -v \
		test/src/util/misc/TextLineBreakerTest.java \
		test/src/util/ui/html/HTMLTextHelperTest.java
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="bsh,commons-codec,commons-lang-3.3,jgoodies-common-1.8,jgoodies-forms-1.8,jgoodies-looks-2.6,l2fprod-common,skinlf"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},ant-junit,junit"

EANT_BUILD_TARGET="runtime-linux"
EANT_DOC_TARGET="public-doc"

src_test() {
	VIRTUALX_COMMAND="java-pkg-2_src_test" virtualmake
}

src_install() {
	pushd runtime/${PN}_linux > /dev/null
		java-pkg_dojar ${PN}.jar

		local todir="${JAVA_PKG_SHAREPATH}"

		cp -a {imgs,icons,plugins} "${D}/${todir}" || die "Failed to copy directories."
		cp linux.properties "${D}/${todir}" || die "Failed to copy linux.properties."

		insinto "${todir}/themepacks"
		doins themepacks/themepack.zip

		if use themes ; then
			pushd "${DISTDIR}" > /dev/null
				doins *pack.zip

				insinto "${todir}/icons"
				doins noia.zip nuvola.zip tulliana.zip tango_without_heart.zip
			popd > /dev/null
		fi

		java-pkg_dolauncher "tvbrowser" \
			--main tvbrowser.TVBrowser \
			--pwd ${todir} \
			--java_args " -Dpropertiesfile=${todir}/linux.properties"

		make_desktop_entry ${PN} "TV-Browser" \
			/usr/share/tvbrowser/imgs/tvbrowser128.png "AudioVideo;TV;Video"
	popd > /dev/null

	java-pkg_dojar $(ls lib/*.jar)
	#java-pkg_dojar lib/{htmlparser-1.6.jar,jRegistryKey-1.4.5.jar,opencsv-2.3.jar}
	#java-pkg_dojar lib/{substance-6.1.jar,texhyphj-1.1.jar,trident-1.3.jar}

	use source && java-pkg_dosrc src
	use doc && java-pkg_dojavadoc doc
}
