# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/frostwire/frostwire-4.20.9.ebuild,v 1.3 2012/05/21 19:35:57 ssuominen Exp $

EAPI=2

inherit eutils java-pkg-2

DESCRIPTION="Frostwire Java Gnutella client"
HOMEPAGE="http://www.frostwire.com"
SRC_URI="mirror://sourceforge/${PN}/${P}.noarch.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-java/aopalliance
	dev-java/commons-logging
	dev-java/commons-net
	dev-java/commons-codec
	dev-java/icu4j:0
	dev-java/jgoodies-looks:1.2
	dev-java/jmdns
	dev-java/jython:0
	dev-java/log4j
	dev-java/xml-commons-external
	>=virtual/jre-1.4"

S="${WORKDIR}/${P}.noarch"

PREFIX="/usr/share/${PN}"

src_prepare() {
	rm -fR commons-logging.jar commons-codec-1.3.jar \
		log4j.jar icu4j.jar jmdns.jar jython.jar \
		aopalliance.jar looks.jar forms.jar \
		junit.jar

	java-pkg_getjars commons-logging,commons-codec
	java-pkg_getjars log4j,icu4j,jmdns,jython,aopalliance-1
	java-pkg_getjars jgoodies-looks-1.2,junit
}

src_install() {
	java-pkg_dojar "${S}/FrostWire.jar"
	java-pkg_dojar "${S}/themes.jar"
	java-pkg_dojar "${S}/splash.jar"

	# Install resources for Frostwire. Don't let the jars deceive ya :)
	# These are directly required, not sure of source atm
	pushd "${D}/usr/share/${PN}"
	ln -s lib/themes.jar
	popd

	# Bundled jars, yeah I know throw up in your mouth some
	# but registering them you say, only doing so for launcher
	bjs="clink.jar daap.jar httpclient-4.0.jar httpcore-4.0.1.jar \
		 httpcore-nio-4.0.1.jar foxtrot.jar gettext-commons.jar \
		gson-1.4.jar guice-1.0.jar jaudiotagger.jar \
		jcip-annotations.jar jcraft.jar jdic.jar jdic_stub.jar \
		jflac.jar jl.jar messages.jar mp3spi.jar onion-common.jar \
		onion-fec.jar ProgressTabs.jar tritonus.jar vorbisspi.jar \
		lw-azureus.jar lw-collection.jar lw-common.jar lw-http.jar \
		lw-io.jar lw-mojito.jar lw-net.jar lw-nio.jar \
		lw-resources.jar lw-rudp.jar lw-security.jar lw-setting.jar \
		lw-statistic.jar \
		"
	for bj in ${bjs}; do
		java-pkg_dojar "${bj}"
	done

	touch "${D}/${PREFIX}/hashes"

	java-pkg_dolauncher ${PN} \
		--main com.limegroup.gnutella.gui.Main \
		--java_args "-Xms64m -Xmx128m -ea -Dorg.apache.commons.logging.Log=org.apache.commons.logging.impl.NoOpLog" \
		--pwd /usr/share/${PN}

	insinto /usr/share/pixmaps
	doins FrostWire.icns

	make_desktop_entry frostwire FrostWire

	dodoc EULA.txt
}
