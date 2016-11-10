# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Netbeans JavaCard Cluster"
HOMEPAGE="http://netbeans.org/projects/javacard"
SLOT="8.2"
SOURCE_URL="http://download.netbeans.org/netbeans/8.2/final/zip/netbeans-8.2-201609300101-src.zip"
SRC_URI="${SOURCE_URL}
	http://dev.gentoo.org/~fordfrog/distfiles/netbeans-8.2-build.xml.patch.bz2
	http://hg.netbeans.org/binaries/33DCFAE258453BDD3D8A042F6ECF80656A82B8DD-anttasks.jar
	http://hg.netbeans.org/binaries/9C1A8BC9D3270D184F1D1BCC5F60AA81D46E1ADF-apduio.jar
	http://hg.netbeans.org/binaries/6243337E93F5841D4FFB404011AA076BFEB1590A-javacard_ri.zip"
LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}"

CDEPEND="virtual/jdk:1.8
	~dev-java/netbeans-extide-${PV}
	~dev-java/netbeans-ide-${PV}
	~dev-java/netbeans-java-${PV}
	~dev-java/netbeans-platform-${PV}"
DEPEND="${CDEPEND}
	app-arch/unzip
	dev-java/javahelp:0"
RDEPEND="${CDEPEND}
	dev-java/ant-contrib:0
	dev-java/asm:3
	dev-java/bcel:0
	dev-java/commons-cli:1
	dev-java/commons-codec:0
	dev-java/commons-httpclient:3
	dev-java/commons-logging:0"

INSTALL_DIR="/usr/share/${PN}-${SLOT}"

EANT_BUILD_XML="nbbuild/build.xml"
EANT_BUILD_TARGET="rebuild-cluster"
EANT_EXTRA_ARGS="-Drebuild.cluster.name=nb.cluster.javacard -Dext.binaries.downloaded=true -Dpermit.jdk8.builds=true"
EANT_FILTER_COMPILER="ecj-3.3 ecj-3.4 ecj-3.5 ecj-3.6 ecj-3.7"
JAVA_PKG_BSFIX="off"

src_unpack() {
	unpack $(basename ${SOURCE_URL})

	einfo "Deleting bundled jars..."
	find -name "*.jar" -type f -delete

	unpack netbeans-8.2-build.xml.patch.bz2

	pushd "${S}" >/dev/null || die
	ln -s "${DISTDIR}"/33DCFAE258453BDD3D8A042F6ECF80656A82B8DD-anttasks.jar javacard.ri.platform/external/anttasks.jar || die
	ln -s "${DISTDIR}"/9C1A8BC9D3270D184F1D1BCC5F60AA81D46E1ADF-apduio.jar javacard.apdu.io/external/apduio.jar || die
	ln -s "${DISTDIR}"/6243337E93F5841D4FFB404011AA076BFEB1590A-javacard_ri.zip javacard.ri.bundle/external/javacard_ri.zip || die
	popd >/dev/null || die
}

src_prepare() {
	einfo "Deleting bundled class files..."
	find -name "*.class" -type f | xargs rm -vf

	epatch netbeans-8.2-build.xml.patch

	einfo "Symlinking external libraries..."
	java-pkg_jar-from --build-only --into javahelp/external javahelp jhall.jar jhall-2.0_05.jar

	einfo "Linking in other clusters..."
	mkdir "${S}"/nbbuild/netbeans || die
	pushd "${S}"/nbbuild/netbeans >/dev/null || die

	ln -s /usr/share/netbeans-extide-${SLOT} extide || die
	cat /usr/share/netbeans-extide-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.extide.built

	ln -s /usr/share/netbeans-ide-${SLOT} ide || die
	cat /usr/share/netbeans-ide-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.ide.built

	ln -s /usr/share/netbeans-java-${SLOT} java || die
	cat /usr/share/netbeans-java-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.java.built

	ln -s /usr/share/netbeans-platform-${SLOT} platform || die
	cat /usr/share/netbeans-platform-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.platform.built

	popd >/dev/null || die

	java-pkg-2_src_prepare
	default
}

src_install() {
	pushd nbbuild/netbeans/javacard >/dev/null || die

	insinto ${INSTALL_DIR}

	grep -E "/javacard$" ../moduleCluster.properties > "${D}"/${INSTALL_DIR}/moduleCluster.properties || die

	doins -r *
	rm -fr "${D}"/${INSTALL_DIR}/bin || die

	popd >/dev/null || die

	local instdir="${D}"/${INSTALL_DIR}/JCDK3.0.2_ConnectedEdition/lib
	pushd "${instdir}" >/dev/null || die
	rm ant-contrib-1.0b3.jar && java-pkg_jar-from --into "${instdir}" ant-contrib ant-contrib.jar ant-contrib-1.0b3.jar
	rm asm-all-3.1.jar && java-pkg_jar-from --into "${instdir}" asm-3 asm.jar asm-all-3.1.jar
	rm bcel-5.2.jar && java-pkg_jar-from --into "${instdir}" bcel bcel.jar bcel-5.2.jar
	rm commons-cli-1.0.jar && java-pkg_jar-from --into "${instdir}" commons-cli-1 commons-cli.jar commons-cli-1.0.jar
	rm commons-codec-1.3.jar && java-pkg_jar-from --into "${instdir}" commons-codec commons-codec.jar commons-codec-1.3.jar
	rm commons-httpclient-3.0.jar && java-pkg_jar-from --into "${instdir}" commons-httpclient-3 commons-httpclient.jar commons-httpclient-3.0.jar
	rm commons-logging-1.1.jar && java-pkg_jar-from --into "${instdir}" commons-logging commons-logging.jar commons-logging-1.1.jar
	popd >/dev/null || die

	dosym ${INSTALL_DIR} /usr/share/netbeans-nb-${SLOT}/javacard
}
