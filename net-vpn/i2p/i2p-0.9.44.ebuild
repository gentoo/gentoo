# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2 systemd

DESCRIPTION="A privacy-centric, anonymous network"
HOMEPAGE="https://geti2p.net"
SRC_URI="https://download.i2p2.de/releases/${PV}/i2psource_${PV}.tar.bz2"

LICENSE="Apache-2.0 Artistic BSD CC-BY-2.5 CC-BY-3.0 CC-BY-SA-3.0 EPL-1.0 GPL-2 GPL-3 LGPL-2.1 LGPL-3 MIT public-domain WTFPL-2"
SLOT="0"

# Until the deps reach other arches
KEYWORDS="~amd64 ~x86"
IUSE="nls test"
RESTRICT="!test? ( test )"

# dev-java/ant-core is automatically added due to java-ant-2.eclass
COMMON_DEPEND="
	dev-java/bcprov:1.50
	dev-java/jrobin:0
	dev-java/slf4j-api:0
	dev-java/tomcat-jstl-impl:0
	dev-java/tomcat-jstl-spec:0
	dev-java/java-service-wrapper:0
	dev-java/commons-logging:0
	dev-java/slf4j-simple:0
	java-virtuals/servlet-api:3.1
"

DEPEND="${COMMON_DEPEND}
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

RDEPEND="${COMMON_DEPEND}
	acct-user/i2p
	acct-group/i2p
	virtual/jre:1.8
	net-libs/nativebiginteger:0
"

EANT_BUILD_TARGET="pkg"
# no scala as depending on antlib.xml not installed by dev-lang/scala
EANT_TEST_TARGET="junit.test"
JAVA_ANT_ENCODING="UTF-8"

src_prepare() {
	if use test; then
		# no *streaming as requiring >dev-java/mockito-1.9.5
		sed -e "/streaming.*junit\.test/d" \
			-i build.xml ||
			die "unable to remove ministreaming tests"
	fi

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
		"installer/resources/clients.config" || die

	# generate wrapper classpath, keeping the default to be replaced later
	i2p_cp="" # global forced by java-pkg_gen-cp
	java-pkg_gen-cp i2p_cp
	local lib i=2
	local cp="wrapper.java.classpath.1=${EPREFIX}/usr/share/i2p/lib/*\n"
	for lib in ${i2p_cp//,/ }
	do
		cp+="wrapper.java.classpath.$((i++))=$(java-pkg_getjars ${lib})\n"
	done

	# add generated cp, hardcode system VM, setting system's conf
	sed -e "s|\(wrapper\.java\.classpath\.1\)=.*|${cp}|" \
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
	# store built version of jars, overwritten by testing
	mv "${S}/pkg-temp/lib/"{i2p,router}.jar "${T}" ||
		die "unable to save jars before tests"

	# generate test classpath
	local cp
	cp="$(java-pkg_getjars --build-only junit-4,hamcrest-core-1.3,hamcrest-library-1.3)"
	EANT_TEST_EXTRA_ARGS="-Djavac.classpath=${cp}" java-pkg-2_src_test

	# redo work undone by testing
	mv "${T}/"{i2p,router}.jar "${S}/pkg-temp/lib/" ||
		die "unable to restore jars after tests"
}

src_install() {
	# cd into pkg-temp.
	cd "${S}/pkg-temp" || die

	# we remove system installed jar and install the others
	rm lib/{jrobin,wrapper,jbigi,commons-logging,javax.servlet}.jar || \
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
	keepdir /var/lib/i2p/app
	keepdir /var/lib/i2p/router
	keepdir /var/lib/i2p/config
	fowners i2p:i2p /var/lib/i2p
}

pkg_postinst() {
	local old_i2pdir="${EPREFIX}/var/lib/i2p/.i2p" new_i2pdir="${EPREFIX}/var/lib/i2p"

	[ -e "${old_i2pdir}" ] || return

	elog "User is now delegated to acct-user, ${new_i2pdir} is split"
	elog "into subdirs. It will now try to split ${old_i2pdir} accordingly."

	migrate() {
		local dest="${1}"
		shift

		local ret=true
		for src
		do
			[ -e "${src}" ] || continue
			mv "${src}" "${dest}" || ret=false
		done

		$ret
	}

	ebegin "Migrating"
	local ret=0
	chown -R i2p:i2p "${EPREFIX}/var/lib/i2p" || ret=1
	migrate "${new_i2pdir}/app" "${old_i2pdir}/i2psnark" || ret=1
	migrate "${new_i2pdir}/config" \
		"${old_i2pdir}/"{docs,eepsite,hosts.txt,prngseed.rnd,*.config*} ||
		ret=1
	migrate "${new_i2pdir}/router" \
		"${old_i2pdir}/"{addressbook,eventlog.txt,hostsdb.blockfile,keyBackup,netDb,peerProfiles,router.*,rrd} ||
		ret=1
	migrate "${EPREFIX}/var/log/i2p" "${old_i2pdir}/"{logs/*,wrapper.log*} ||
		ret=1
	rm -fr "${old_i2pdir}/"{hostsdb.blockfile.*.corrupt,logs}
	rmdir "${old_i2pdir}" || ret=1

	if ! eend $ret
	then
		ewarn "There was some file remaining in ${old_i2pdir}."
		ewarn "Please check it there is something of value there."
		ewarn "remove it when migration is done."
	fi
}
