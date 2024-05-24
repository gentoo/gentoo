# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="test"

inherit java-pkg-2 java-ant-2 systemd toolchain-funcs

DESCRIPTION="A privacy-centric, anonymous network"
HOMEPAGE="https://geti2p.net"
SRC_URI="https://files.i2p-projekt.de/${PV}/i2psource_${PV}.tar.bz2"

LICENSE="Apache-2.0 Artistic BSD CC-BY-2.5 CC-BY-3.0 CC-BY-SA-3.0 EPL-1.0 GPL-2 GPL-3 LGPL-2.1 LGPL-3 MIT public-domain WTFPL-2"
SLOT="0"

KEYWORDS="amd64 ~arm ~arm64 ~x86"
LANGS=(
	ar az bg ca cs da de el en es es-AR et fa fi fr gl he hi hr hu id it ja ko ku mg nb nl nn pl pt pt-BR ro ru sk sl sq
	sr sv tk tr uk vi zh zh-TW
)
IUSE="${LANGS[@]/#/l10n_}"

CP_DEPEND="
	dev-java/bcprov:0
	dev-java/hashcash:1
	dev-java/httpcomponents-client:4
	dev-java/identicon:1
	dev-java/java-getopt:1
	dev-java/java-service-wrapper:0
	dev-java/jbcrypt:0
	dev-java/json-simple:2.3
	dev-java/json-smart:1
	dev-java/jsonrpc2-base:1
	dev-java/jsonrpc2-server:1
	dev-java/jstl:0
	dev-java/jstl-api:0
	dev-java/minidns-core:1
	dev-java/zxing-core:3
	dev-java/zxing-javase:3
	sys-devel/gettext:0[java]
	www-servers/tomcat:9
"
# jdk-11 for bug #932030
DEPEND="
	dev-libs/gmp:0=
	${CP_DEPEND}
	>=virtual/jdk-11:*
	test? (
		>=dev-java/ant-1.10.14-r3:0[junit4]
		dev-java/hamcrest:0
		dev-java/junit:4
		dev-java/mockito:4
	)
"
RDEPEND="
	${CP_DEPEND}
	acct-user/i2p
	acct-group/i2p
	>=virtual/jre-11:*
"

PATCHES=(
	"${FILESDIR}/fix-junit-classpath.patch"
)

EANT_BUILD_TARGET="preppkg-base"
# no scala as depending on antlib.xml not installed by dev-lang/scala
EANT_TEST_TARGET="junit.test"
JAVA_ANT_ENCODING="UTF-8"
JAVA_ANT_CLASSPATH_TAGS="javac java"
# built locally
EANT_GENTOO_CLASSPATH_EXTRA="${S}/core/java/build/i2p.jar"
EANT_GENTOO_CLASSPATH_EXTRA+=":${S}/router/java/build/router.jar"
EANT_GENTOO_CLASSPATH_EXTRA+=":${S}/apps/ministreaming/java/build/mstreaming.jar"

DOCS=( README.md history.txt )

src_prepare() {
	default # apply PATCHES
	java-pkg-2_src_prepare

	# add our classpath
	for f in `find -name build.xml`
	do
		java-ant_rewrite-classpath "$f"
	done

	# remove most bundled, excepted the next ones.
	# apps/addressbook/java/src/net/metanotion too much code drift
	# apps/i2psnark/java/src/org/klomp/snark too much code drift
	# apps/jrobin need rrd4j ebuild
	# apps/routerconsole/java/src/{com,edu} too much code drift
	# {core,router}/java/src/com/southernstorm/noise use internal symbols
	# core/java/src/freenet too much code drift
	# core/java/src/gnu/crypto too much code drift
	# router/java/src/com/maxmind changed interface
	# router/java/src/org/cybergarage unable to find version 3
	# router/java/src/org/freenetproject too big to pull
	# router/java/src/org/xlattice changed interface
	java-pkg_clean ! \
		-path "./apps/jetty/jetty-distribution-*" # need to package jetty
	( cat >> override.properties || die 'set unbundled properties' ) <<- EOF
		require.gettext=true
		with-libgetopt-java=true
		with-libjakarta-taglibs-standard-java=true
		with-libjson-simple-java=true
		with-libtomcat9-java=true
		with-gettext-base=true
		# with-geoip-database=true need std geoip use
		# with-libjetty9-java=true needs a jetty ebuild
	EOF

	# bcprov
	rm -r core/java/src/net/i2p/crypto/elgamal || die 'unbundle bcprov'
	sed -e 's,net\.i2p\.crypto\.elgamal\.impl,org.bouncycastle.jce.provider,' \
		-e 's,net\.i2p\.crypto\.elgamal\.spec,org.bouncycastle.jce.spec,' \
		-i core/java/src/net/i2p/crypto/{provider/I2PProvider,CryptoConstants}.java ||
		die 'redirect imports of bcprov'
	# getopt, gettext
	rm -r core/java/src/gnu/{getopt,gettext} || die 'unbundle GNU code'
	# httpcomponents-client
	rm -r core/java/src/net/i2p/apache || die 'unbundle httpcomponents-client'
	sed -e 's,net\.i2p\.apache,org.apache,' \
		-i core/java/src/net/i2p/util/{Addresses,I2PSSLSocketFactory}.java \
			apps/i2pcontrol/java/net/i2p/i2pcontrol/HostCheckHandler.java ||
		die 'redirect imports of httpcomponents-client'
	# identicon, zxing
	rm -r apps/imagegen/{identicon,zxing} || die 'unbundle identicon & zxing'
	sed -e '/LICENSE-Identicon.txt/d' -i build.xml &&
	sed -E '/dir="[^"]*(identicon|zxing)/d' -i apps/imagegen{/imagegen,}/build.xml &&
	sed -E '/(todir="build\/WEB-INF\/classes"|<\/copy>)/d' -i apps/imagegen/imagegen/build.xml ||
		die 'do not depend on unbundled'
	# hashcash
	rm core/java/src/com/nettgryppa/security/HashCash.java ||
		die 'unbundle hashcash'
	# jbcrypt, jsonrpc2-*
	rm -r apps/i2pcontrol/java/{com,org} || die 'unbundle jbcrypt & jsonrpc2-*'
	# jstl*
	sed -E '/"apps\/susidns\/src\/lib\/(jstl|standard).jar"/d' -i build.xml ||
		die 'unbundle jstl*'
	# minidns-core, json-simple
	rm -r core/java/src/org || die 'unbundle minidns-core & json-simple'

	# keep only enabled locales
	local lang
	for lang in ${LANGS[@]}
	do
		if ! use "l10n_${lang}"
		then
			find -regextype egrep \
					-regex ".*[_\\./]${lang/-/_}.(html|po|1)" \
				-delete || die "unbundling ${lang} translations"
		fi
	done

	# fix some locale names
	find -name '*_in.*' -exec rename --no-overwrite _in. _id. {} \; &&
	find -name '*_iw.*' -exec rename --no-overwrite _iw. _he. {} \; ||
		die 'fix some locale names'
}

src_configure() {
	java-ant-2_src_configure

	# deamon shouldn't start GUI
	sed -i 's|\(clientApp.4.startOnLoad\)=true|\1=false|' \
		installer/resources/clients.config ||
		die 'avoid auto starting browser'

	# yep, that's us
	echo "build.built-by=Gentoo" >> override.properties ||
		die 'bragging failed'
}

src_compile() {
	java-pkg-2_src_compile

	local compile_lib
	compile_lib() {
		local name="${1}"
		local file="${2}"
		shift 2

		"$(tc-getCC)" "${@}" ${CFLAGS} $(java-pkg_get-jni-cflags) \
			${LDFLAGS} -shared -fPIC "-Wl,-soname,lib${name}.so" \
			"${file}" -o "lib${name}.so"
	}

	cd "${S}/core/c/jbigi/jbigi" || die "unable to cd to jbigi"
	compile_lib jbigi src/jbigi.c -Iinclude -lgmp ||
		die "unable to build jbigi"

	if use amd64 || use x86; then
		cd "${S}/core/c/jcpuid" || die "unable to cd to jcpuid"
		compile_lib jcpuid src/jcpuid.c -Iinclude ||
			die "unable to build jcpuid"
	fi
}

src_test() {
	# avoid rebuilding
	sed -e '/<delete dir=".\/build" \/>/d' -i core/java/build.xml ||
		die 'avoid building twice'

	# halt on error
	find -name build.xml \
		-execdir sed -e 's/<junit /\0haltonerror="yes" /' -i {} + ||
		die 'ensure test failures propagate'

	EANT_GENTOO_CLASSPATH+=",hamcrest,junit-4,mockito-4"
	java-pkg-2_src_test
}

src_install() {
	# install basic documentation
	einstalldocs
	doman installer/resources/man/eepget.*

	# install main files
	java-pkg_doso core/c/jbigi/jbigi/libjbigi.so
	if use amd64 || use x86; then
		java-pkg_doso core/c/jcpuid/libjcpuid.so
	fi
	cd "${S}/pkg-temp" || die 'unable to change dir to built artifacts'
	java-pkg_dojar lib/*.jar
	java-pkg_dowar webapps/*.war

	# install shared
	insinto /usr/share/i2p
	doins blocklist.txt hosts.txt {clients,i2p*}.config
	doins -r certificates docs eepsite geoip scripts

	# install daemons
	newinitd "${FILESDIR}/i2p.init" i2p
	systemd_dounit "${FILESDIR}/i2p.service"

	# setup dirs
	keepdir /var/log/i2p /var/lib/i2p
	fowners i2p:i2p /var/lib/i2p /var/log/i2p

	# create own launchers
	java-pkg_dolauncher i2prouter --main net.i2p.router.Router --jar i2p.jar \
		--pwd "${EPREFIX}/usr/share/i2p" \
		--java_args "\
			-Di2p.dir.config=${EPREFIX}/var/lib/i2p \
			-Di2p.dir.log=${EPREFIX}/var/log/i2p \
			-DloggerFilenameOverride=${EPREFIX}/var/log/i2p/router-@"
	java-pkg_dolauncher eepget --main net.i2p.util.EepGet --jar i2p.jar
}

pkg_postinst() {
	local i2pdir="${EPREFIX}/var/lib/i2p"

	[ -d "${i2pdir}/app" -a -d "${i2pdir}/config" -a -d "${i2pdir}/router" ] || return

	elog "Separated user directories is not fully supported by upstream."
	elog "${i2pdir}/{app,config,router} will be merged"
	elog "in ${i2pdir} accordingly."

	ebegin "Migrating"
	rm -fr "${i2pdir}/config/addressbook" # prefer router's addressbook
	local ret=0
	mv "${i2pdir}"/{app,config,router}/* "${i2pdir}" || ret=1
	rmdir "${i2pdir}"/{app,config,router} || ret=1
	find "${i2pdir}" '(' -name '*.config' -o -name '*.xml' ')' \
		-execdir sed -E "s,${i2pdir}/(app|config|router),${i2pdir}," -i {} + || ret=1

	if ! eend $ret
	then
		ewarn "Unable to merge user directories automatically."
		ewarn "Please merge them by hand and update all configured paths"
		ewarn "to point to ${i2pdir} before starting the router."
		ewarn
		ewarn "Otherwise, consider starting with a fresh router by removing ${i2pdir}."
	fi
}
