# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Netbeans JavaFX Cluster"
HOMEPAGE="https://netbeans.org/projects/javafx"
SLOT="8.2"
SOURCE_URL="https://download.netbeans.org/netbeans/8.2/final/zip/netbeans-8.2-201609300101-src.zip"
SRC_URI="${SOURCE_URL}
	https://dev.gentoo.org/~fordfrog/distfiles/netbeans-8.2-build.xml.patch.bz2
	https://hg.netbeans.org/binaries/A806D99716C5E9441BFD8B401176FDDEFC673022-bindex-2.2.jar
	https://hg.netbeans.org/binaries/D325D3913CBC0F9A8D73A466FABB98EDEEC014AB-jemmy-2.3.1.1.jar
	https://hg.netbeans.org/binaries/D06C8980C9025183C044202419EA29E69FBD4B99-jemmy-2.3.1.1-doc.zip
	https://hg.netbeans.org/binaries/49197106637CCA8C337AF16CC01BB5D9DEC7E179-jemmy-2.3.1.1-src.zip
	https://hg.netbeans.org/binaries/20D826CC819A5A969CF3F7204E2E26CB6263EC43-jnlp-servlet.jar
	https://hg.netbeans.org/binaries/5D007C6037A8501E73A3D3FB98A1F6AE5768C3DD-nb-javac-api.jar"
LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
KEYWORDS="amd64 ~x86"
IUSE=""
S="${WORKDIR}"

CDEPEND="virtual/jdk:1.8
	~dev-java/netbeans-extide-${PV}
	~dev-java/netbeans-ide-${PV}
	~dev-java/netbeans-java-${PV}
	~dev-java/netbeans-platform-${PV}"
DEPEND="${CDEPEND}
	app-arch/unzip
	dev-java/javahelp:0
	dev-java/junit:4"
RDEPEND="${CDEPEND}"

INSTALL_DIR="/usr/share/${PN}-${SLOT}"

EANT_BUILD_XML="nbbuild/build.xml"
EANT_BUILD_TARGET="rebuild-cluster"
EANT_EXTRA_ARGS="-Drebuild.cluster.name=nb.cluster.javafx -Dext.binaries.downloaded=true -Dpermit.jdk8.builds=true"
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
	ln -s "${DISTDIR}"/5D007C6037A8501E73A3D3FB98A1F6AE5768C3DD-nb-javac-api.jar libs.javacapi/external/nb-javac-api.jar || die
	popd >/dev/null || die
}

src_prepare() {
	einfo "Deleting bundled class files..."
	find -name "*.class" -type f | xargs rm -vf

	eapply netbeans-8.2-build.xml.patch

	einfo "Symlinking external libraries..."
	java-pkg_jar-from --build-only --into apisupport.harness/external javahelp jsearch.jar jsearch-2.0_05.jar
	java-pkg_jar-from --build-only --into javahelp/external javahelp jhall.jar jhall-2.0_05.jar
	java-pkg_jar-from --build-only --into libs.junit4/external junit-4 junit.jar junit-4.12.jar

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
	pushd nbbuild/netbeans/javafx >/dev/null || die

	insinto ${INSTALL_DIR}

	grep -E "/javafx$" ../moduleCluster.properties > "${D}"/${INSTALL_DIR}/moduleCluster.properties || die

	doins -r *

	popd >/dev/null || die

	dosym ${INSTALL_DIR} /usr/share/netbeans-nb-${SLOT}/javafx
}
