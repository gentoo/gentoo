# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple systemd verify-sig

DESCRIPTION="An encrypted network without censorship"
HOMEPAGE="https://www.hyphanet.org"
PEV="3.1.6"
SRC_URI="https://github.com/hyphanet/fred/releases/download/build0${PV#*p}/freenet-build0${PV#*p}-source.tar.bz2
	https://github.com/hyphanet/seedrefs/archive/build01480.tar.gz -> seednodes-0.7.5_p1480.tar.gz
	verify-sig? (
		https://github.com/hyphanet/fred/releases/download/build0${PV#*p}/freenet-build0${PV#*p}-source.tar.bz2.sig
	)"
S="${WORKDIR}/freenet-build0${PV#*p}"

LICENSE="GPL-2+ GPL-2 MIT BSD-2 Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64"
IUSE="+nss"

CP_DEPEND="
	dev-java/bcprov:0
	dev-java/commons-compress:0
	dev-java/commons-io:1
	dev-java/fec:0
	dev-java/freenet-ext:29
	dev-java/java-service-wrapper:0
	dev-java/jbitcollider-core:0
	dev-java/jna:4
	dev-java/lzma:0
	dev-java/lzmajio:0
	dev-java/mersennetwister:0
	dev-java/pebble:0
"

DEPEND="
	dev-java/unbescape:0
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? (
		dev-java/hamcrest:0
		dev-java/mockito:0
		dev-java/objenesis:0
		net-libs/NativeThread:0
	)
"
RDEPEND="
	acct-user/freenet
	acct-group/freenet
	>=virtual/jre-1.8:*
	${CP_DEPEND}
	nss? ( dev-libs/nss )
"
BDEPEND="
	app-arch/unzip
	verify-sig? ( sec-keys/openpgp-keys-freenet )
"
PDEPEND="net-libs/NativeThread:0"

DOCS=(
	AUTHORS
	CONTRIBUTING.md
	NEWS.md
	README.md
	SECURITY.md
)

PATCHES=(
	"${FILESDIR}/freenet-0.7.5_p1498-ignore-failing-tests.patch"
)

JAVA_CLASSPATH_EXTRA="
	java-service-wrapper
	unbescape
"
JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR="src"
JAVA_TEST_GENTOO_CLASSPATH="
	hamcrest
	junit-4
	mockito
	objenesis
"
# Yes, both variables point to the same directory
# https://github.com/hyphanet/fred/blob/build01497/build.gradle#L169-L173
JAVA_TEST_RESOURCE_DIRS="test"
JAVA_TEST_SRC_DIR="test"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/freenetproject.org.asc"
src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached \
			"${DISTDIR}"/freenet-build0${PV#*p}-source.tar.bz2 \
			"${DISTDIR}"/freenet-build0${PV#*p}-source.tar.bz2.sig
	fi
	unpack freenet-build0${PV#*p}-source.tar.bz2
	unpack seednodes-0.7.5_p1480.tar.gz
}

src_prepare() {
	default
	java-pkg-2_src_prepare

	# Could not get resource : freenet/l10n/freenet.l10n.pt-PT.properties
	# https://github.com/hyphanet/fred/pull/500
	mv src/freenet/l10n/freenet.l10n.pt{_,-}PT.properties || die

	# java-pkg-simple wants resources in JAVA_RESOURCE_DIRS
	mkdir res || die
	pushd src  > /dev/null || die
		find -type f \
			! -name '*.java' \
			! -name 'package.html' \
			! -path '*/simulator/readme.txt' \
			| xargs cp --parent -t ../res || die
	popd > /dev/null || die

	mkdir "${JAVA_RESOURCE_DIRS}/META-INF" || die
	cat > "${JAVA_RESOURCE_DIRS}/META-INF/MANIFEST.MF" <<- EOF || die
		Add-opens: java.base/java.lang java.base/java.util java.base/java.io
	EOF

	cat "${WORKDIR}"/seedrefs-build01480/* > "${S}"/seednodes.fref
	cp "${FILESDIR}"/freenet-0.7.5_p1497-wrapper.conf freenet-wrapper.conf || die
	cp "${FILESDIR}"/run.sh-20090501 run.sh || die

	sed -i -e "s:=/usr/lib:=/usr/$(get_libdir):g" \
		freenet-wrapper.conf || die "sed failed"

	echo "wrapper.java.classpath.1=/usr/share/freenet/lib/freenet.jar" >> freenet-wrapper.conf || die
	if use nss; then
		echo "wrapper.java.additional.11=-Dfreenet.jce.use.NSS=true" >> freenet-wrapper.conf || die
	fi
}

src_compile() {
	java-pkg-simple_src_compile

	# Moved here because of using JAVA_GENTOO_CLASSPATH which is populated by java-pkg_gen-cp.
	local i=2 pkg jars jar
	local ifs_original=${IFS}
	IFS=","
	for pkg in ${JAVA_GENTOO_CLASSPATH} ; do
		jars="$(java-pkg_getjars ${pkg})"
		for jar in ${jars} ; do
			echo "wrapper.java.classpath.$((i++))=${jar}" >> freenet-wrapper.conf || die
		done
	done
	IFS=${ifs_original}
	echo "wrapper.java.library.path.2=/usr/$(get_libdir)/java-service-wrapper" >> freenet-wrapper.conf || die
	echo "wrapper.java.library.path.3=/usr/$(get_libdir)/jna-4" >> freenet-wrapper.conf || die
}

src_test() {
	JAVA_TEST_EXTRA_ARGS=(
		-Djava.library.path="${EPREFIX}/usr/$(get_libdir)/jna-4/"
		-Djna.nosys=false
		-Dnetworkaddress.cache.negative.ttl=0
		-Dnetworkaddress.cache.ttl=0
		# https://github.com/hyphanet/fred/blob/build01497/build.gradle#L194-L196
		# "test.l10npath_main" reads from the JAR file.
		-Dtest.l10npath_test="freenet/l10n/"
		-Dtest.l10npath_main="freenet/l10n/"
	)
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=(
			--add-opens=java.base/java.io=ALL-UNNAMED
			--add-opens=java.base/java.lang=ALL-UNNAMED
			--add-opens=java.base/java.util=ALL-UNNAMED
		)
	fi

	pushd test > /dev/null || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			-type f  -name "*Test.java" \
			)
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
		JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	popd > /dev/null || die
	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install

	doinitd "${FILESDIR}"/freenet

	systemd_dounit "${FILESDIR}"/freenet.service

	insinto /etc
	doins freenet-wrapper.conf
	insinto /var/freenet
	doins run.sh seednodes.fref
	fperms +x /var/freenet/run.sh
}

pkg_postinst() {
	elog " "
	elog "1. Start freenet with rc-service freenet start."
	elog "2. Open localhost:8888 in your browser for the web interface."
	#workaround for previously existing freenet user
	[[ $(stat --format="%U" /var/freenet) == "freenet" ]] || chown \
		freenet:freenet /var/freenet
}

pkg_postrm() {
	if ! [[ -e /usr/share/freenet/lib/freenet.jar ]] ; then
		elog " "
		elog "If you dont want to use freenet any more"
		elog "and dont want to keep your identity/other stuff"
		elog "remember to do 'rm -rf /var/freenet' to remove everything"
	fi
}
