# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DATE=20160521
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2 multilib systemd user

DESCRIPTION="An encrypted network without censorship"
HOMEPAGE="https://freenetproject.org/"
#	https://github.com/${PN}/seedrefs/archive/build0${PV#*p}.zip -> seednodes-${PV}.zip
SRC_URI="
	https://github.com/${PN}/fred/archive/build0${PV#*p}.zip -> ${P}.zip
	https://github.com/${PN}/seedrefs/archive/build01480.zip -> seednodes-0.7.5_p1480.zip
	mirror://gentoo/freenet-ant-1.7.1.jar"

LICENSE="GPL-2+ GPL-2 MIT BSD-2 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+nss test"

CDEPEND="dev-java/bcprov:1.54
	dev-java/commons-compress:0
	dev-java/fec:0
	dev-java/java-service-wrapper:0
	dev-java/jbitcollider-core:0
	dev-java/jna:0
	dev-java/lzma:0
	dev-java/lzmajio:0
	dev-java/mersennetwister:0
	nss? ( dev-libs/nss )"

DEPEND="
	app-arch/unzip
	>=virtual/jdk-1.7
	${CDEPEND}
	test? (
		dev-java/junit:0
		dev-java/ant-junit:0
	)
	dev-java/ant-core:0"

RDEPEND="
	>=virtual/jre-1.7
	net-libs/nativebiginteger:0
	${CDEPEND}"

PDEPEND="net-libs/NativeThread:0"

JAVA_PKG_BSFIX_NAME+=" build-clean.xml"
JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS+=" javadoc"
JAVA_ANT_ENCODING="utf8"

EANT_BUILD_TARGET="package"
EANT_TEST_TARGET="unit"
EANT_BUILD_XML="build-clean.xml"
EANT_GENTOO_CLASSPATH="bcprov-1.54,commons-compress,fec,java-service-wrapper,jbitcollider-core,jna,lzma,lzmajio,mersennetwister"
EANT_EXTRA_ARGS="-Dsuppress.gjs=true -Dlib.contrib.present=true -Dlib.bouncycastle.present=true -Dlib.junit.present=true -Dtest.skip=true"

S="${WORKDIR}/fred-build0${PV#*p}"

RESTRICT="test" # they're broken in the last release.

MY_PATCHES=(
	"${FILESDIR}"/0.7.5_p1483-ext.patch
	"${FILESDIR}/"0.7.5_p1475-remove-git.patch
)

pkg_setup() {
	has_version dev-java/icedtea[cacao] && {
		ewarn "dev-java/icedtea was built with cacao USE flag."
		ewarn "freenet may compile with it, but it will refuse to run."
		ewarn "Please remerge dev-java/icedtea without cacao USE flag,"
		ewarn "if you plan to use it for running freenet."
	}
	java-pkg-2_pkg_setup
	enewgroup freenet
	enewuser freenet -1 -1 /var/freenet freenet
}

src_unpack() {
#	unpack ${P}.zip seednodes-${PV}.zip
	unpack ${P}.zip seednodes-0.7.5_p1480.zip
}

src_prepare() {
#	cat "${WORKDIR}"/seedrefs-build0${PV#*p}/* > "${S}"/seednodes.fref
	cat "${WORKDIR}"/seedrefs-build01480/* > "${S}"/seednodes.fref
	cp "${FILESDIR}"/freenet-0.7.5_p1474-wrapper.conf freenet-wrapper.conf || die
	cp "${FILESDIR}"/run.sh-20090501 run.sh || die
	cp "${FILESDIR}"/build-clean.xml build-clean.xml || die
	cp "${FILESDIR}"/build.properties build.properties || die

	epatch "${MY_PATCHES[@]}"

	sed -i -e "s:=/usr/lib:=/usr/$(get_libdir):g" \
		freenet-wrapper.conf || die "sed failed"

	echo "wrapper.java.classpath.1=/usr/share/freenet/lib/freenet.jar" >> freenet-wrapper.conf || die
	if use nss; then
		echo "wrapper.java.additional.5=-Dfreenet.jce.use.NSS=true" >> freenet-wrapper.conf || die
	fi
	local i=2 pkg jars jar
	local ifs_original=${IFS}
	IFS=","
	for pkg in ${EANT_GENTOO_CLASSPATH} ; do
		jars="$(java-pkg_getjars ${pkg})"
		for jar in ${jars} ; do
			echo "wrapper.java.classpath.$((i++))=${jar}" >> freenet-wrapper.conf || die
		done
	done
	IFS=${ifs_original}
	echo "wrapper.java.classpath.$((i++))=/usr/share/freenet/lib/ant.jar" >> freenet-wrapper.conf || die

	cp "${DISTDIR}"/freenet-ant-1.7.1.jar lib/ant.jar || die
	eapply_user
}

EANT_TEST_EXTRA_ARGS="-Dtest.skip=false"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar dist/freenet.jar
	java-pkg_newjar "${DISTDIR}"/freenet-ant-1.7.1.jar ant.jar

	if has_version =sys-apps/baselayout-2*; then
		doinitd "${FILESDIR}"/freenet
	else
		newinitd "${FILESDIR}"/freenet.old freenet
	fi

	systemd_dounit "${FILESDIR}"/freenet.service

	dodoc AUTHORS
	newdoc README.md README
	insinto /etc
	doins freenet-wrapper.conf
	insinto /var/freenet
	doins run.sh seednodes.fref
	fperms +x /var/freenet/run.sh
	dosym java-service-wrapper/libwrapper.so /usr/$(get_libdir)/libwrapper.so
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src
}

pkg_postinst() {
	elog " "
	elog "1. Start freenet with /etc/init.d/freenet start."
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
