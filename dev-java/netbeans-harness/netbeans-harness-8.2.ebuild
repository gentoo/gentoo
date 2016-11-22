# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Netbeans Harness"
HOMEPAGE="http://netbeans.org/features/platform/"
SLOT="8.2"
SOURCE_URL="http://download.netbeans.org/netbeans/8.2/final/zip/netbeans-8.2-201609300101-src.zip"
SRC_URI="${SOURCE_URL}
	http://dev.gentoo.org/~fordfrog/distfiles/netbeans-8.2-build.xml.patch.bz2
	http://hg.netbeans.org/binaries/A806D99716C5E9441BFD8B401176FDDEFC673022-bindex-2.2.jar
	http://hg.netbeans.org/binaries/D325D3913CBC0F9A8D73A466FABB98EDEEC014AB-jemmy-2.3.1.1.jar
	http://hg.netbeans.org/binaries/D06C8980C9025183C044202419EA29E69FBD4B99-jemmy-2.3.1.1-doc.zip
	http://hg.netbeans.org/binaries/49197106637CCA8C337AF16CC01BB5D9DEC7E179-jemmy-2.3.1.1-src.zip
	http://hg.netbeans.org/binaries/20D826CC819A5A969CF3F7204E2E26CB6263EC43-jnlp-servlet.jar"
LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}"

CDEPEND="virtual/jdk:1.8
	~dev-java/netbeans-platform-${PV}
	dev-java/javahelp:0"
DEPEND="${CDEPEND}
	app-arch/unzip
	>=dev-java/junit-4.4:4"
RDEPEND="${CDEPEND}"

INSTALL_DIR="/usr/share/${PN}-${SLOT}"

EANT_BUILD_XML="nbbuild/build.xml"
EANT_BUILD_TARGET="rebuild-cluster"
EANT_EXTRA_ARGS="-Drebuild.cluster.name=nb.cluster.harness -Dext.binaries.downloaded=true -Dpermit.jdk8.builds=true"
EANT_FILTER_COMPILER="ecj-3.3 ecj-3.4 ecj-3.5 ecj-3.6 ecj-3.7"
JAVA_PKG_BSFIX="off"

src_unpack() {
	unpack $(basename ${SOURCE_URL})

	einfo "Deleting bundled jars..."
	find -name "*.jar" -type f -delete

	unpack netbeans-8.2-build.xml.patch.bz2

	pushd "${S}" >/dev/null || die
	ln -s "${DISTDIR}"/A806D99716C5E9441BFD8B401176FDDEFC673022-bindex-2.2.jar apisupport.harness/external/bindex-2.2.jar || die
	ln -s "${DISTDIR}"/20D826CC819A5A969CF3F7204E2E26CB6263EC43-jnlp-servlet.jar apisupport.harness/external/jnlp-servlet.jar || die
	ln -s "${DISTDIR}"/D325D3913CBC0F9A8D73A466FABB98EDEEC014AB-jemmy-2.3.1.1.jar jemmy/external/jemmy-2.3.1.1.jar || die
	ln -s "${DISTDIR}"/D06C8980C9025183C044202419EA29E69FBD4B99-jemmy-2.3.1.1-doc.zip jemmy/external/jemmy-2.3.1.1-doc.zip || die
	ln -s "${DISTDIR}"/49197106637CCA8C337AF16CC01BB5D9DEC7E179-jemmy-2.3.1.1-src.zip jemmy/external/jemmy-2.3.1.1-src.zip || die
	popd >/dev/null || die
}

src_prepare() {
	einfo "Deleting bundled class files..."
	find -name "*.class" -type f | xargs rm -vf

	epatch netbeans-8.2-build.xml.patch

	einfo "Symlinking external libraries..."
	java-pkg_jar-from --into javahelp/external javahelp jhall.jar jhall-2.0_05.jar
	java-pkg_jar-from --into apisupport.harness/external javahelp jsearch.jar jsearch-2.0_05.jar
	java-pkg_jar-from --build-only --into libs.junit4/external junit-4 junit.jar junit-4.12.jar

	einfo "Linking in other clusters..."
	mkdir "${S}"/nbbuild/netbeans || die
	pushd "${S}"/nbbuild/netbeans >/dev/null || die

	ln -s /usr/share/netbeans-platform-${SLOT} platform || die
	cat /usr/share/netbeans-platform-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.platform.built

	popd >/dev/null || die

	java-pkg-2_src_prepare
	default
}

src_install() {
	pushd nbbuild/netbeans/harness >/dev/null || die

	insinto ${INSTALL_DIR}

	grep -E "/harness$" ../moduleCluster.properties > "${D}"/${INSTALL_DIR}/moduleCluster.properties || die

	doins -r *
	fperms 755 launchers/app.sh
	find "${D}" -name "*.exe" -type f -delete

	popd >/dev/null || die

	local instdir="${D}"/${INSTALL_DIR}/antlib
	pushd "${instdir}" >/dev/null || die
	rm jsearch-2.0_05.jar && java-pkg_jar-from --into "${instdir}" javahelp jsearch.jar jsearch-2.0_05.jar
	popd >/dev/null || die

	dosym ${INSTALL_DIR} /usr/share/netbeans-nb-${SLOT}/harness
}
