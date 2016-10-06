# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Netbeans Web Services Cluster"
HOMEPAGE="http://netbeans.org/"
SLOT="8.2"
SOURCE_URL="http://download.netbeans.org/netbeans/8.2/final/zip/netbeans-8.2-201609300101-src.zip"
SRC_URI="${SOURCE_URL}
	http://dev.gentoo.org/~fordfrog/distfiles/netbeans-8.2-build.xml.patch.bz2
	http://hg.netbeans.org/binaries/7CA13589F586F659BB0E1561719A91CA47BF1897-com.oracle.js.parser.jar
	http://hg.netbeans.org/binaries/59631804B5A7FF3CEAA3F0E113584AF7E1BB6E9B-dd-plist.jar
	http://hg.netbeans.org/binaries/7C4A82593A85524A3541E55A4A9C906B773ABAD6-ios-sim
	http://hg.netbeans.org/binaries/C8EEAB10E4539BEAF97476EBA252BD4B40377FA9-js-corestubs.zip
	http://hg.netbeans.org/binaries/2AA13ACCC4059C930C4AD3B6ABD8E1C0FC06235C-js-domstubs.zip
	http://hg.netbeans.org/binaries/7C0C3CFD989EE775198337C11715C1ACD6C84F41-js-reststubs.zip
	http://hg.netbeans.org/binaries/0929AC5F40B5A8667021408748D64F30F77B3165-libiDeviceNativeBinding.dylib
	http://hg.netbeans.org/binaries/2A38DA3DB5D36DBBDC0B03990B46810F72430D5E-libimobiledevice.4.dylib
	http://hg.netbeans.org/binaries/480C9E376169E21EA3BDA5D5841425BD7CC054D7-libplist.1.dylib
	http://hg.netbeans.org/binaries/08FE518AB60FFA2E5440B75B4D9F8502E0791B3C-libs.jstestdriver-ext.jar
	http://hg.netbeans.org/binaries/C1BB9FF4232248B0054E5A26A33474A251EA19CB-libusbmuxd.2.dylib
	http://hg.netbeans.org/binaries/D4BD3F62EADB61216A47EF96B3152EDD35A56005-ojetdocs-1_0_0.zip
	http://hg.netbeans.org/binaries/1EFED55F8C442E4DB1C2338A5C35D494364F9ECD-ojetdocs-1_1_2.zip
	http://hg.netbeans.org/binaries/CA8F6968FED0BE20E786C70CF9B603F4D7B66C68-ojetdocs-2_0_0.zip"
LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}"

CDEPEND="~dev-java/netbeans-platform-${PV}
	~dev-java/netbeans-extide-${PV}
	~dev-java/netbeans-ide-${PV}"
DEPEND=">=virtual/jdk-1.7
	app-arch/unzip
	${CDEPEND}
	dev-java/javahelp:0
	dev-java/jna:0"
RDEPEND="|| ( virtual/jdk:1.7 virtual/jdk:1.8 )
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

	unpack netbeans-8.2-build.xml.patch.bz2

	pushd "${S}" >/dev/null || die
	ln -s "${DISTDIR}"/7CA13589F586F659BB0E1561719A91CA47BF1897-com.oracle.js.parser.jar libs.nashorn/external/com.oracle.js.parser.jar || die
	ln -s "${DISTDIR}"/59631804B5A7FF3CEAA3F0E113584AF7E1BB6E9B-dd-plist.jar libs.plist/external/dd-plist.jar || die
	ln -s "${DISTDIR}"/7C4A82593A85524A3541E55A4A9C906B773ABAD6-ios-sim cordova.platforms.ios/external/ios-sim || die
	ln -s "${DISTDIR}"/C8EEAB10E4539BEAF97476EBA252BD4B40377FA9-js-corestubs.zip javascript2.editor/external/js-corestubs.zip || die
	ln -s "${DISTDIR}"/2AA13ACCC4059C930C4AD3B6ABD8E1C0FC06235C-js-domstubs.zip javascript2.editor/external/js-domstubs.zip || die
	ln -s "${DISTDIR}"/7C0C3CFD989EE775198337C11715C1ACD6C84F41-js-reststubs.zip javascript2.editor/external/js-reststubs.zip || die
	ln -s "${DISTDIR}"/0929AC5F40B5A8667021408748D64F30F77B3165-libiDeviceNativeBinding.dylib cordova.platforms.ios/external/libiDeviceNativeBinding.dylib || die
	ln -s "${DISTDIR}"/2A38DA3DB5D36DBBDC0B03990B46810F72430D5E-libimobiledevice.4.dylib cordova.platforms.ios/external/libimobiledevice.4.dylib || die
	ln -s "${DISTDIR}"/480C9E376169E21EA3BDA5D5841425BD7CC054D7-libplist.1.dylib cordova.platforms.ios/external/libplist.1.dylib || die
	ln -s "${DISTDIR}"/08FE518AB60FFA2E5440B75B4D9F8502E0791B3C-libs.jstestdriver-ext.jar libs.jstestdriver/external/libs.jstestdriver-ext.jar || die
	ln -s "${DISTDIR}"/C1BB9FF4232248B0054E5A26A33474A251EA19CB-libusbmuxd.2.dylib cordova.platforms.ios/external/libusbmuxd.2.dylib || die
	ln -s "${DISTDIR}"/D4BD3F62EADB61216A47EF96B3152EDD35A56005-ojetdocs-1_0_0.zip html.ojet/external/ojetdocs-1_0_0.zip || die
	ln -s "${DISTDIR}"/1EFED55F8C442E4DB1C2338A5C35D494364F9ECD-ojetdocs-1_1_2.zip html.ojet/external/ojetdocs-1_1_2.zip || die
	ln -s "${DISTDIR}"/CA8F6968FED0BE20E786C70CF9B603F4D7B66C68-ojetdocs-2_0_0.zip html.ojet/external/ojetdocs-2_0_0.zip || die
	popd >/dev/null || die
}

src_prepare() {
	einfo "Deleting bundled class files..."
	find -name "*.class" -type f | xargs rm -vf

	epatch netbeans-8.2-build.xml.patch

	einfo "Symlinking external libraries..."
	java-pkg_jar-from --build-only --into javahelp/external javahelp jhall.jar jhall-2.0_05.jar
	java-pkg_jar-from --build-only --into libs.jna/external jna jna.jar jna-4.2.2.jar

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
	default
}

src_install() {
	pushd nbbuild/netbeans/webcommon >/dev/null || die

	insinto ${INSTALL_DIR}
	grep -E "/webcommon$" ../moduleCluster.properties > "${D}"/${INSTALL_DIR}/moduleCluster.properties || die
	doins -r *

	popd >/dev/null || die

	dosym ${INSTALL_DIR} /usr/share/netbeans-nb-${SLOT}/webcommon
}
