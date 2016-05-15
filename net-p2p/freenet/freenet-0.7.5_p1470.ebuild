# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
DATE=20150812
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2 multilib systemd user

DESCRIPTION="An encrypted network without censorship"
HOMEPAGE="https://freenetproject.org/"
SRC_URI="https://github.com/${PN}/fred/archive/build0${PV#*p}.zip -> ${P}.zip
	mirror://gentoo/seednodes-${DATE}.fref.bz2
	mirror://gentoo/freenet-ant-1.7.1.jar"

LICENSE="GPL-2+ GPL-2 MIT BSD-2 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="dev-java/bcprov:1.52
	dev-java/commons-compress:0
	dev-db/db-je:3.3
	dev-java/fec:0
	dev-java/java-service-wrapper:0
	dev-java/db4o-jdk11:0
	dev-java/db4o-jdk12:0
	dev-java/db4o-jdk5:0
	dev-java/jbitcollider-core:0
	dev-java/lzma:0
	dev-java/lzmajio:0
	dev-java/mersennetwister:0"
DEPEND="app-arch/unzip
	>=virtual/jdk-1.6
	${CDEPEND}
	test? ( dev-java/junit:0
		dev-java/ant-junit:0 )
	dev-java/ant-core:0"
RDEPEND=">=virtual/jre-1.6
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
EANT_GENTOO_CLASSPATH="bcprov-1.52,commons-compress,db4o-jdk5,db4o-jdk12,db4o-jdk11,db-je-3.3,fec,java-service-wrapper,jbitcollider-core,lzma,lzmajio,mersennetwister"
EANT_EXTRA_ARGS="-Dsuppress.gjs=true -Dlib.contrib.present=true -Dlib.bouncycastle.present=true -Dlib.junit.present=true -Dtest.skip=true"

S=${WORKDIR}/fred-build0${PV#*p}

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
	unpack ${P}.zip seednodes-${DATE}.fref.bz2
	mv "${WORKDIR}"/freenet-fred-* "${S}"
}

java_prepare() {
	cp "${FILESDIR}"/freenet-0.7.5_p1422-wrapper.conf freenet-wrapper.conf || die
	cp "${FILESDIR}"/run.sh-20090501 run.sh || die
	epatch "${FILESDIR}"/0.7.5_p1321-ext.patch

	sed -i -e "s:=/usr/lib:=/usr/$(get_libdir):g" \
		freenet-wrapper.conf || die "sed failed"

	echo "wrapper.java.classpath.1=/usr/share/freenet/lib/freenet.jar" >> freenet-wrapper.conf

	local i=2 pkg jars jar
	local ifs_original=${IFS}
	IFS=","
	for pkg in ${EANT_GENTOO_CLASSPATH} ; do
		jars="$(java-pkg_getjars ${pkg})"
		for jar in ${jars} ; do
			echo "wrapper.java.classpath.$((i++))=${jar}" >> freenet-wrapper.conf
		done
	done
	IFS=${ifs_original}
	echo "wrapper.java.classpath.$((i++))=/usr/share/freenet/lib/ant.jar" >> freenet-wrapper.conf

	cp "${DISTDIR}"/freenet-ant-1.7.1.jar lib/ant.jar || die
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
	dodoc AUTHORS || die
	newdoc README.md README || die
	insinto /etc
	doins freenet-wrapper.conf || die
	insinto /var/freenet
	doins run.sh || die
	newins "${WORKDIR}"/seednodes-${DATE}.fref seednodes.fref || die
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
