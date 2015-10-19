# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils java-pkg-2 java-ant-2 systemd user

DESCRIPTION="A privacy-centric, anonymous network."
HOMEPAGE="https://geti2p.net"
SRC_URI="https://download.i2p2.de/releases/${PV}/i2psource_${PV}.tar.bz2"

LICENSE="Apache-2.0 Artistic BSD CC-BY-2.5 CC-BY-3.0 CC-BY-SA-3.0 EPL-1.0 GPL-2 GPL-3 LGPL-2.1 LGPL-3 MIT public-domain WTFPL-2"
SLOT="0"

# Until the deps reach other arches
KEYWORDS="~amd64 ~x86"
IUSE="nls"

# dev-java/ant-core is automatically added due to java-ant-2.eclass
CDEPEND="dev-java/jrobin:0
	dev-java/slf4j-api:0
	dev-java/java-service-wrapper:0"

DEPEND="${CDEPEND}
	dev-java/eclipse-ecj:*
	dev-libs/gmp:*
	nls? ( sys-devel/gettext )
	>=virtual/jdk-1.6"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"

EANT_BUILD_TARGET="pkg"
EANT_GENTOO_CLASSPATH="java-service-wrapper,jrobin,slf4j-api"

pkg_setup() {
	enewgroup i2p
	enewuser i2p -1 -1 /var/lib/i2p i2p -m
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	java-ant_rewrite-classpath
}

src_prepare() {
	# We're on GNU/Linux, we don't need .exe files
	echo "noExe=true" > override.properties
	if ! use nls; then
		echo "require.gettext=false" >> override.properties
	fi
}

src_install() {
	# Cd into pkg-temp.
	cd "${S}/pkg-temp" || die

	# Apply patch.
	epatch "${FILESDIR}/${P}_fix-paths.patch"

	# Using ${D} here results in an error. Docs say use $ROOT
	i2p_home="${ROOT}/usr/share/i2p"

	# This is ugly, but to satisfy all non-system .jar dependencies, jetty and
	# systray4j would need to be packaged. The former would be too large a task
	# for an unseasoned developer and systray4j hasn't been touched in over 10
	# years. This seems to be the most pragmatic solution
	java-pkg_jarinto "${i2p_home}/lib"
	for i in BOB commons-el commons-logging i2p i2psnark i2ptunnel \
		jasper-compiler jasper-runtime javax.servlet jbigi jetty* mstreaming org.mortbay.* router* \
		sam standard streaming systray systray4j; do
		java-pkg_dojar lib/${i}.jar
	done

	# Set up symlinks for binaries
	dosym /usr/bin/wrapper ${i2p_home}/i2psvc
	dosym ${i2p_home}/i2prouter /usr/bin/i2prouter
	dosym ${i2p_home}/eepget /usr/bin/eepget

	# Install main files and basic documentation
	exeinto ${i2p_home}
	insinto ${i2p_home}
	#doins blocklist.txt hosts.txt *.config
	doexe eepget i2prouter runplain.sh
	dodoc history.txt INSTALL-headless.txt LICENSE.txt
	doman man/*

	# Install other directories
	doins -r certificates docs eepsite geoip scripts
	dodoc -r licenses
	java-pkg_dowar webapps/*.war

	# Install daemon files
	newinitd "${FILESDIR}/i2p.initd" i2p
	systemd_newunit "${FILESDIR}"/i2p.service i2p.service
}

pkg_postinst() {
	elog "Custom configuration belongs in /var/lib/i2p/.i2p/ to avoid being overwritten."
	elog "I2P can be configured through the web interface at http://localhost:7657/index.jsp"
}
