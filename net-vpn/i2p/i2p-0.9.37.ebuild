# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit java-pkg-2 java-ant-2 systemd user

DESCRIPTION="A privacy-centric, anonymous network"
HOMEPAGE="https://geti2p.net"
SRC_URI="https://download.i2p2.de/releases/${PV}/i2psource_${PV}.tar.bz2"

LICENSE="Apache-2.0 Artistic BSD CC-BY-2.5 CC-BY-3.0 CC-BY-SA-3.0 EPL-1.0 GPL-2 GPL-3 LGPL-2.1 LGPL-3 MIT public-domain WTFPL-2"
SLOT="0"

# Until the deps reach other arches
KEYWORDS="~amd64 ~x86"
IUSE="+ecdsa nls test"

# dev-java/ant-core is automatically added due to java-ant-2.eclass
CP_DEPEND='dev-java/bcprov:1.50
	dev-java/jrobin:0
	dev-java/slf4j-api:0
	dev-java/tomcat-jstl-impl:0
	dev-java/tomcat-jstl-spec:0
	dev-java/java-service-wrapper:0
	dev-java/commons-logging:0
	dev-java/slf4j-simple:0
	java-virtuals/servlet-api:3.1
'

DEPEND="${CP_DEPEND}
	dev-java/eclipse-ecj:*
	nls? ( >=sys-devel/gettext-0.19 )
	virtual/jdk:1.8
	test? (
		dev-java/ant-junit4:0
		dev-java/hamcrest-core:1.3
		dev-java/hamcrest-library:1.3
		dev-java/junit:4
	)
"

RDEPEND="${CP_DEPEND}
	ecdsa? (
		|| (
			dev-java/icedtea:8[-sunec]
			dev-java/icedtea-bin:8
			dev-java/oracle-jre-bin
			dev-java/oracle-jdk-bin
		)
	)
	!ecdsa? ( virtual/jre:1.8 )
	net-libs/nativebiginteger:0
"

EANT_BUILD_TARGET="pkg"
# no scala as depending on antlib.xml not installed by dev-lang/scala
EANT_TEST_TARGET='junit.test'
JAVA_ANT_ENCODING="UTF-8"

PATCHES=(
	"${FILESDIR}/${PV}-add-cp-to-tests"
)

pkg_setup() {
	java-pkg-2_pkg_setup

	enewgroup i2p
	enewuser i2p -1 -1 "${EPREFIX}/var/lib/i2p" i2p
}

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
	sed -i 's|clientApp.4.startOnLoad=true|clientApp.4.startOnLoad=false|' \
		'installer/resources/clients.config' || die

	# generate wrapper classpath, keeping the default to be replaced later
	i2p_cp='' # global forced by java-pkg_gen-cp
	java-pkg_gen-cp i2p_cp
	local lib cp i=2
	for lib in ${i2p_cp//,/ }
	do
		cp+="wrapper.java.classpath.$((i++))=$(java-pkg_getjars ${lib})\n"
	done

	# add generated cp and hardcode system VM
	sed -e "s|\(wrapper\.java\.classpath\.1=.*\)|\1\n${cp}|" \
		-e "s|\(wrapper\.java\.command\)=.*|\1=/etc/java-config-2/current-system-vm/bin/java|" \
		-e "s|\(wrapper\.java\.library\.path\.1\)=.*|\1=/usr/lib/java-service-wrapper|" \
		-e "s|\(wrapper\.java\.library\.path\.2\)=.*|\0\nwrapper.java.library.path.3=/usr/$(get_libdir)|" \
		-i 'installer/resources/wrapper.config' || die

	# replace paths as the installer would
	sed -e "s|[\$%]INSTALL_PATH|${EPREFIX}/usr/share/i2p|" \
		-e "s|%SYSTEM_java_io_tmpdir|${EPREFIX}/var/lib/i2p/.i2p|" \
		-e "s|%USER_HOME|${EPREFIX}/var/lib/i2p|" \
		-i 'installer/resources/'{eepget,runplain.sh,wrapper.config} || die

	if use test; then
		# no *streaming as requiring >dev-java/mockito-1.9.5
		sed -e '/junit\.test.*streaming/d' \
			-i build.xml ||
			die 'unable to remove ministreaming tests'
	fi
}

src_test() {
	# store built version of jars, overwritten by testing
	mv "${S}/pkg-temp/lib/"{i2p,router}.jar "${T}" ||
		die 'unable to save jars before tests'

	# generate test classpath
	local cp
	cp="$(java-pkg_getjars --build-only junit-4,hamcrest-core-1.3,hamcrest-library-1.3)"
	EANT_TEST_EXTRA_ARGS="-Djavac.classpath=${cp}" java-pkg-2_src_test

	# redo work undone by testing
	mv "${T}/"{i2p,router}.jar "${S}/pkg-temp/lib/" ||
		die 'unable to restore jars after tests'
}

src_install() {
	# cd into pkg-temp.
	cd "${S}/pkg-temp" || die

	# we remove system installed jar and install the others
	rm lib/{jrobin,wrapper,jbigi,commons-logging,javax.servlet}.jar || \
		die 'unable to remove locally built jar already found in system'
	java-pkg_dojar lib/*.jar

	# create own launcher
	java-pkg_dolauncher eepget --main net.i2p.util.EepGet --jar i2p.jar

	# Install main files and basic documentation
	insinto '/usr/share/i2p'
	doins blocklist.txt hosts.txt *.config
	dodoc history.txt INSTALL-headless.txt LICENSE.txt
	doman man/*

	# Install other directories
	doins -r certificates docs eepsite geoip scripts
	java-pkg_dowar webapps/*.war

	# Install daemon files
	newinitd "${FILESDIR}/i2p.init" i2p
	systemd_dounit "${FILESDIR}/i2p.service"

	# setup user
	keepdir '/var/lib/i2p/.i2p'
	fowners i2p:i2p '/var/lib/i2p/.i2p'
}

pkg_postinst() {
	elog "Custom configuration belongs in ${EPREFIX}/var/lib/i2p/.i2p to avoid being overwritten."
	elog 'I2P can be configured through the web interface at http://localhost:7657/console'

	if use !ecdsa
	then
		ewarn 'Currently, the i2p team does not enforce to use ECDSA keys. But it is more and'
		ewarn 'more pushed. To help the network, you are recommended to have the ecdsa USE.'
		ewarn
		ewarn "This is purely a run-time issue. You're free to build i2p with any JDK, as long as"
		ewarn 'the JVM you run it with is one of the above listed and from the same or a newer generation'
		ewarn 'as the one you built with.'
	fi
}
