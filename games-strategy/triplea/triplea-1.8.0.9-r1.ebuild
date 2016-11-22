# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils java-pkg-2 java-ant-2 versionator

MY_PV=$(replace_all_version_separators _)
DESCRIPTION="An open source clone of the popular Axis and Allies boardgame"
HOMEPAGE="http://triplea.sourceforge.net/"
SRC_URI="mirror://sourceforge/triplea/${PN}_${MY_PV}_source_code_only.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test" # Needs X11 maybe use virtualx.eclass

RDEPEND="dev-java/apple-java-extensions-bin:0
	dev-java/commons-httpclient:3
	dev-java/oracle-javamail:0
	dev-java/osgi-core-api:0
	dev-java/upnplib:0"
DEPEND="${RDEPEND}
	>=virtual/jdk-1.7
	app-arch/unzip
	test? ( dev-java/ant-junit:0 )"
RDEPEND="${RDEPEND}
	>=virtual/jre-1.7"

S=${WORKDIR}/${PN}_${MY_PV}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="apple-java-extensions-bin,commons-httpclient-3,oracle-javamail,osgi-core-api,upnplib"

java_prepare() {
	# Use ~/.triplea, not ~/triplea.
	# Don't write server files under /usr/share or ${PWD}.
	# Fix to build against our packaged upnplib.
	epatch "${FILESDIR}"/{paths,upnplib}.patch

	# Remove packaged or unneeded libs. Unfortunately Apache Derby was
	# last-rited due to packaging issues. See bug #561410.
	find lib/* ! -name "derby-*.jar" -delete || die
	rm -r old/ || die
}

src_compile() {
	eant
	echo "triplea.saveGamesInHomeDir=true" > data/triplea.properties || die
	# The only target creating this is zip which does unjar etc
	jar cf ${PN}.jar -C classes . || die
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	insinto /usr/share/${PN}
	doins -r assets data dice_servers maps

	java-pkg_dojar ${PN}.jar
	java-pkg_newjar lib/derby-*.jar derby.jar

	java-pkg_dolauncher ${PN} \
		--main games.strategy.engine.framework.GameRunner \
		--java_args "-Xmx256m"
	java-pkg_dolauncher ${PN}-server -pre "${FILESDIR}"/mkdir.sh \
		--main games.strategy.engine.lobby.server.LobbyServer \
		--java_args "-server -Xmx64m -Dtriplea.lobby.port=3303 -Dtriplea.lobby.console=true"

	newicon icons/triplea_icon.png ${PN}.png
	newicon icons/triplea_icon.png ${PN}-server.png
	make_desktop_entry ${PN} TripleA
	make_desktop_entry ${PN}-server TripleA-server

	dodoc changelog.txt TripleA_RuleBook.pdf
	docinto html
	dodoc -r doc/* readme.html
}
