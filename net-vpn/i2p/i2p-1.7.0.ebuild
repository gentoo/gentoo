# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2 systemd

DESCRIPTION="A privacy-centric, anonymous network"
HOMEPAGE="https://geti2p.net"
SRC_URI="https://files.i2p-projekt.de/${PV}/i2psource_${PV}.tar.bz2"

LICENSE="Apache-2.0 Artistic BSD CC-BY-2.5 CC-BY-3.0 CC-BY-SA-3.0 EPL-1.0 GPL-2 GPL-3 LGPL-2.1 LGPL-3 MIT public-domain WTFPL-2"
SLOT="0"

# Until the deps reach other arches
KEYWORDS="~amd64 ~arm ~x86"
IUSE="nls test"
RESTRICT="!test? ( test )"

# dev-java/ant-core is automatically added due to java-ant-2.eclass
CP_DEPEND="dev-java/java-service-wrapper:0"

DEPEND="${CP_DEPEND}
	|| (
		virtual/jdk:1.8
		virtual/jdk:11
	)
	nls? ( >=sys-devel/gettext-0.19 )
	test? (
		dev-java/ant-junit4:0
		dev-java/hamcrest-core:1.3
		dev-java/hamcrest-library:1.3
		dev-java/junit:4
		dev-java/mockito:4
	)
"

RDEPEND="${CP_DEPEND}
	acct-user/i2p
	acct-group/i2p
	net-libs/nativebiginteger:0
	|| (
		virtual/jre:1.8
		virtual/jre:11
	)
"

EANT_BUILD_TARGET="pkg"
# no scala as depending on antlib.xml not installed by dev-lang/scala
EANT_TEST_TARGET="junit.test"
JAVA_ANT_ENCODING="UTF-8"

src_prepare() {
	# as early as possible to allow generic patches to be applied
	default

	java-ant_rewrite-classpath

	java-pkg-2_src_prepare

	# We're on GNU/Linux, we don't need .exe files
	echo "noExe=true" > override.properties || die
	if ! use nls; then
		echo "require.gettext=false" >> override.properties || die
	fi

	# avoid auto starting browser
	sed -i "s|clientApp.4.startOnLoad=true|clientApp.4.startOnLoad=false|" \
		installer/resources/clients.config || die

	# generate wrapper classpath, keeping the default to be replaced later
	i2p_cp="" # global forced by java-pkg_gen-cp
	java-pkg_gen-cp i2p_cp
	local lib i=2
	local classpath="wrapper.java.classpath.1=${EPREFIX}/usr/share/i2p/lib/*\n"
	for lib in ${i2p_cp//,/ }
	do
		classpath+="wrapper.java.classpath.$((i++))=$(java-pkg_getjars ${lib})\n"
	done

	# add generated classpath, hardcode system VM, setting system's conf
	sed -e "s|\(wrapper\.java\.classpath\.1\)=.*|${classpath}|" \
		-e "s|\(wrapper\.java\.command\)=.*|\1=/etc/java-config-2/current-system-vm/bin/java|" \
		-e "s|\(wrapper\.java\.library\.path\.1\)=.*|\1=/usr/$(get_libdir)/java-service-wrapper|" \
		-e "s|\(wrapper\.java\.library\.path\)\.2=.*|\1.2=${EPREFIX}/usr/share/i2p/lib\n\1.3=/usr/$(get_libdir)|" \
		-e "s|\(wrapper\.java\.additional\.1=-DloggerFilenameOverride\)=.*|\1=${EPREFIX}/var/log/i2p/router-@|" \
		-e "s|\(wrapper\.logfile\)=.*|\1=${EPREFIX}/var/log/i2p/wrapper|" \
		-e "/wrapper\.java\.additional\.2\(\.stripquote\|\)/d" \
		-i installer/resources/wrapper.config ||
		die "unable to apply gentoo config"
	local prop i=2
	for prop in \
		"i2p.dir.base=${EPREFIX}/usr/share/i2p" \
		"i2p.dir.app=${EPREFIX}/var/lib/i2p/app" \
		"i2p.dir.config=${EPREFIX}/var/lib/i2p/config" \
		"i2p.dir.router=${EPREFIX}/var/lib/i2p/router" \
		"i2p.dir.log=${EPREFIX}/var/log/i2p" \
		"i2p.dir.pid=${EPREFIX}/tmp" \
		"i2p.dir.temp=${EPREFIX}/tmp"
	do
		echo "wrapper.java.additional.$((i++))=-D$prop" >> installer/resources/wrapper.config ||
			die "unable to apply gentoo config"
	done
}

src_test() {
	# generate test classpath
	local classpath="$(java-pkg_getjars --build-only junit-4,hamcrest-core-1.3,hamcrest-library-1.3,mockito-4)"
	EANT_TEST_EXTRA_ARGS="-Djavac.classpath=${classpath}" java-pkg-2_src_test
}

src_install() {
	# cd into pkg-temp.
	cd "${S}/pkg-temp" || die

	# we remove system installed jar and install the others
	rm lib/wrapper.jar || \
		die "unable to remove locally built jar already found in system"
	java-pkg_dojar lib/*.jar

	# create own launcher
	java-pkg_dolauncher eepget --main net.i2p.util.EepGet --jar i2p.jar

	# Install main files and basic documentation
	insinto "/usr/share/i2p"
	doins blocklist.txt hosts.txt *.config
	dodoc history.txt INSTALL-headless.txt LICENSE.txt
	doman man/*

	# Install other directories
	doins -r certificates docs eepsite geoip scripts
	java-pkg_dowar webapps/*.war

	# Install daemon files
	newinitd "${FILESDIR}/i2p.init" i2p
	systemd_dounit "${FILESDIR}/i2p.service"

	# setup log
	keepdir /var/log/i2p
	fowners i2p:i2p /var/log/i2p

	# setup user
	keepdir /var/lib/i2p
	fowners i2p:i2p /var/lib/i2p
}
