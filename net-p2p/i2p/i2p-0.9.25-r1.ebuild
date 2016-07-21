# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils java-pkg-2 java-ant-2 systemd user

DESCRIPTION="A privacy-centric, anonymous network."
HOMEPAGE="https://geti2p.net"
SRC_URI="https://download.i2p2.de/releases/${PV}/i2psource_${PV}.tar.bz2"

LICENSE="Apache-2.0 Artistic BSD CC-BY-2.5 CC-BY-3.0 CC-BY-SA-3.0 EPL-1.0 GPL-2 GPL-3 LGPL-2.1 LGPL-3 MIT public-domain WTFPL-2"
SLOT="0"

# Until the deps reach other arches
KEYWORDS="~amd64 ~x86"
IUSE="+ecdsa nls"

# dev-java/ant-core is automatically added due to java-ant-2.eclass
CDEPEND="dev-java/bcprov:1.50
	dev-java/jrobin:0
	dev-java/slf4j-api:0
	dev-java/tomcat-jstl-impl:0
	dev-java/tomcat-jstl-spec:0
	dev-java/java-service-wrapper:0"

DEPEND="${CDEPEND}
	dev-java/eclipse-ecj:*
	dev-libs/gmp:*
	nls? ( sys-devel/gettext )
	>=virtual/jdk-1.7"

RDEPEND="${CDEPEND}
	ecdsa? (
		|| (
			dev-java/icedtea:7[-sunec]
			dev-java/icedtea:8[-sunec]
			dev-java/icedtea:7[nss,-sunec]
			dev-java/icedtea-bin:7[nss]
			dev-java/icedtea-bin:7
			dev-java/icedtea-bin:8
			dev-java/oracle-jre-bin
			dev-java/oracle-jdk-bin
		)
	)
	!ecdsa? ( >=virtual/jre-1.7 )"

EANT_BUILD_TARGET="pkg"
EANT_GENTOO_CLASSPATH="java-service-wrapper,jrobin,slf4j-api,tomcat-jstl-impl,tomcat-jstl-spec,bcprov-1.50"
JAVA_ANT_ENCODING="UTF-8"

I2P_ROOT='/usr/share/i2p'
I2P_CONFIG_HOME='/var/lib/i2p'
I2P_CONFIG_DIR="${I2P_HOME}/.i2p"

pkg_setup() {
	java-pkg-2_pkg_setup

	enewgroup i2p
	enewuser i2p -1 -1 "${I2P_CONFIG_HOME}" i2p -m
}

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	java-ant_rewrite-classpath
}

src_prepare() {
	java-pkg-2_src_prepare

	# We're on GNU/Linux, we don't need .exe files
	echo "noExe=true" > override.properties
	if ! use nls; then
		echo "require.gettext=false" >> override.properties
	fi
	eapply_user
}

src_install() {
	# add libs
	eapply "${FILESDIR}/${PN}-0.9.25-add_libs.patch"

	# Cd into pkg-temp.
	cd "${S}/pkg-temp" || die

	# avoid auto starting browser
	sed -i 's|clientApp.4.startOnLoad=true|clientApp.4.startOnLoad=false|' \
		clients.config || die

	# replace paths as the installer would
	sed -i "s|%INSTALL_PATH|${I2P_ROOT}|" \
		eepget i2prouter runplain.sh  || die
	sed -i "s|\$INSTALL_PATH|${I2P_ROOT}|" wrapper.config || die
	sed -i "s|%SYSTEM_java_io_tmpdir|${I2P_CONFIG_DIR}|" \
		i2prouter runplain.sh || die
	sed -i "s|%USER_HOME|${I2P_CONFIG_HOME}|" i2prouter || die

	# This is ugly, but to satisfy all non-system .jar dependencies, jetty and
	# systray4j would need to be packaged. The former would be too large a task
	# for an unseasoned developer and systray4j hasn't been touched in over 10
	# years. This seems to be the most pragmatic solution
	java-pkg_jarinto "${I2P_ROOT}/lib"
	for i in BOB commons-el commons-logging i2p i2psnark i2ptunnel \
		jasper-compiler jasper-runtime javax.servlet jbigi jetty* mstreaming org.mortbay.* router* \
		sam standard streaming systray systray4j; do
		java-pkg_dojar lib/${i}.jar
	done

	# Set up symlinks for binaries
	dosym /usr/bin/wrapper "${I2P_ROOT}/i2psvc"
	dosym "${I2P_ROOT}/i2prouter" /usr/bin/i2prouter
	dosym "${I2P_ROOT}/eepget" /usr/bin/eepget

	# Install main files and basic documentation
	exeinto "${I2P_ROOT}"
	insinto "${I2P_ROOT}"
	doins blocklist.txt hosts.txt *.config
	doexe eepget i2prouter runplain.sh
	dodoc history.txt INSTALL-headless.txt LICENSE.txt
	doman man/*

	# Install other directories
	doins -r certificates docs eepsite geoip scripts
	dodoc -r licenses
	java-pkg_dowar webapps/*.war

	# Install daemon files
	newinitd "${FILESDIR}/${PN}-0.9.25-initd" i2p
	systemd_newunit "${FILESDIR}"/i2p.service i2p.service

	# setup user
	dodir "${I2P_CONFIG_DIR}"
	fowners -R i2p:i2p "${I2P_CONFIG_DIR}"
}

pkg_postinst() {
	elog "Custom configuration belongs in /var/lib/i2p/.i2p/ to avoid being overwritten."
	elog "I2P can be configured through the web interface at http://localhost:7657/index.jsp"

	ewarn 'Currently, the i2p team does not enforce to use ECDSA keys. But it is more and'
	ewarn 'more pushed. To help the network, you are recommended to have either:'
	ewarn '  dev-java/icedtea[-sunec,nss]'
	ewarn '  dev-java/icedtea-bin[nss]'
	ewarn '  dev-java/icedtea[-sunec] and bouncycastle (bcprov)'
	ewarn '  dev-java/icedtea-bin and bouncycastle (bcprov)'
	ewarn '  dev-java/oracle-jre-bin'
	ewarn '  dev-java/oracle-jdk-bin'
	ewarn 'Alternatively you can just use Ed25519 keys - which is a stronger algorithm anyways.'
	ewarn
	ewarn "This is purely a run-time issue. You're free to build i2p with any JDK, as long as"
	ewarn 'the JVM you run it with is one of the above listed and from the same or a newer generation'
	ewarn 'as the one you built with.'

}
