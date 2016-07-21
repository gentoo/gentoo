# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Netbeans Web Services Cluster"
HOMEPAGE="http://netbeans.org/"
SLOT="8.1"
SOURCE_URL="http://download.netbeans.org/netbeans/8.1/final/zip/netbeans-8.1-201510222201-src.zip"
SRC_URI="${SOURCE_URL}
	http://dev.gentoo.org/~fordfrog/distfiles/netbeans-8.1-build.xml.patch.bz2
	http://hg.netbeans.org/binaries/59631804B5A7FF3CEAA3F0E113584AF7E1BB6E9B-dd-plist.jar
	http://hg.netbeans.org/binaries/7C4A82593A85524A3541E55A4A9C906B773ABAD6-ios-sim
	http://hg.netbeans.org/binaries/9D29F2A9722C91A403F32971E97DD0E49E97B02E-libiDeviceNativeBinding.dylib
	http://hg.netbeans.org/binaries/9F0D0D95F57E73C0110FA023813A4F9756D543B1-libimobiledevice.4.dylib
	http://hg.netbeans.org/binaries/480C9E376169E21EA3BDA5D5841425BD7CC054D7-libplist.1.dylib
	http://hg.netbeans.org/binaries/08FE518AB60FFA2E5440B75B4D9F8502E0791B3C-libs.jstestdriver-ext.jar
	http://hg.netbeans.org/binaries/D05B7274396C8EED185207399B6D0400DE347DB7-libusbmuxd.2.dylib"
LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}"

CDEPEND="~dev-java/netbeans-platform-${PV}
	~dev-java/netbeans-extide-${PV}
	~dev-java/netbeans-ide-${PV}
	dev-java/commons-compress:0"
DEPEND=">=virtual/jdk-1.7
	app-arch/unzip
	${CDEPEND}
	dev-java/javahelp:0"
RDEPEND=">=virtual/jdk-1.7
	${CDEPEND}"

INSTALL_DIR="/usr/share/${PN}-${SLOT}"

EANT_BUILD_XML="nbbuild/build.xml"
EANT_BUILD_TARGET="rebuild-cluster"
EANT_EXTRA_ARGS="-Drebuild.cluster.name=nb.cluster.webcommon -Dext.binaries.downloaded=true -Dpermit.jdk8.builds=true"
EANT_FILTER_COMPILER="ecj-3.3 ecj-3.4 ecj-3.5 ecj-3.6 ecj-3.7"
JAVA_PKG_BSFIX="off"

src_unpack() {
	unpack $(basename ${SOURCE_URL})

	einfo "Deleting bundled jars..."
	find -name "*.jar" -type f -delete

	unpack netbeans-8.1-build.xml.patch.bz2

	pushd "${S}" >/dev/null || die
	ln -s "${DISTDIR}"/59631804B5A7FF3CEAA3F0E113584AF7E1BB6E9B-dd-plist.jar libs.plist/external/dd-plist.jar || die
	ln -s "${DISTDIR}"/7C4A82593A85524A3541E55A4A9C906B773ABAD6-ios-sim cordova.platforms.ios/external/ios-sim || die
	ln -s "${DISTDIR}"/9D29F2A9722C91A403F32971E97DD0E49E97B02E-libiDeviceNativeBinding.dylib cordova.platforms.ios/external/libiDeviceNativeBinding.dylib || die
	ln -s "${DISTDIR}"/9F0D0D95F57E73C0110FA023813A4F9756D543B1-libimobiledevice.4.dylib cordova.platforms.ios/external/libimobiledevice.4.dylib || die
	ln -s "${DISTDIR}"/480C9E376169E21EA3BDA5D5841425BD7CC054D7-libplist.1.dylib cordova.platforms.ios/external/libplist.1.dylib || die
	ln -s "${DISTDIR}"/08FE518AB60FFA2E5440B75B4D9F8502E0791B3C-libs.jstestdriver-ext.jar libs.jstestdriver/external/libs.jstestdriver-ext.jar || die
	ln -s "${DISTDIR}"/D05B7274396C8EED185207399B6D0400DE347DB7-libusbmuxd.2.dylib cordova.platforms.ios/external/libusbmuxd.2.dylib || die
	popd >/dev/null || die
}

src_prepare() {
	einfo "Deleting bundled class files..."
	find -name "*.class" -type f | xargs rm -vf

	epatch netbeans-8.1-build.xml.patch

	# Support for custom patches
	if [ -n "${NETBEANS9999_PATCHES_DIR}" -a -d "${NETBEANS9999_PATCHES_DIR}" ] ; then
		local files=`find "${NETBEANS9999_PATCHES_DIR}" -type f`

		if [ -n "${files}" ] ; then
			einfo "Applying custom patches:"

			for file in ${files} ; do
				epatch "${file}"
			done
		fi
	fi

	einfo "Symlinking external libraries..."
	java-pkg_jar-from --into libs.commons_compress/external commons-compress commons-compress.jar commons-compress-1.8.1.jar
	java-pkg_jar-from --build-only --into javahelp/external javahelp jhall.jar jhall-2.0_05.jar

	einfo "Linking in other clusters..."
	mkdir "${S}"/nbbuild/netbeans || die
	pushd "${S}"/nbbuild/netbeans >/dev/null || die

	ln -s /usr/share/netbeans-platform-${SLOT} platform || die
	cat /usr/share/netbeans-platform-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.platform.built

	ln -s /usr/share/netbeans-extide-${SLOT} extide || die
	cat /usr/share/netbeans-extide-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.extide.built

	ln -s /usr/share/netbeans-ide-${SLOT} ide || die
	cat /usr/share/netbeans-ide-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.ide.built

	popd >/dev/null || die

	java-pkg-2_src_prepare
}

src_install() {
	pushd nbbuild/netbeans/webcommon >/dev/null || die

	insinto ${INSTALL_DIR}
	grep -E "/webcommon$" ../moduleCluster.properties > "${D}"/${INSTALL_DIR}/moduleCluster.properties || die
	doins -r *

	popd >/dev/null || die

	local instdir=/${INSTALL_DIR}/modules/ext
	pushd "${D}"/${instdir} >/dev/null || die
	rm commons-compress-1.8.1.jar  && dosym /usr/share/commons-compress/lib/commons-compress.jar ${instdir}/commons-compress-1.8.1.jar || die
	popd >/dev/null || die

	dosym ${INSTALL_DIR} /usr/share/netbeans-nb-${SLOT}/webcommon
}
