# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Netbeans PHP Cluster"
HOMEPAGE="http://netbeans.org/projects/php"
SLOT="8.2"
SOURCE_URL="http://download.netbeans.org/netbeans/8.2/final/zip/netbeans-8.2-201609300101-src.zip"
SRC_URI="${SOURCE_URL}
	https://dev.gentoo.org/~fordfrog/distfiles/netbeans-8.2-build.xml.patch.bz2
	http://hg.netbeans.org/binaries/0702230EB3354A1687E4496D73A94F33A1E343BD-phpdocdesc.zip
	http://hg.netbeans.org/binaries/472A52636BE09823B4E5F707071B31FB990A7375-phpsigfiles.zip
	http://hg.netbeans.org/binaries/3D6AF75EA20D715887DAF47A3F063864EF0814C1-predefined_vars.zip"
LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
KEYWORDS="amd64 ~x86"
IUSE=""
S="${WORKDIR}"

CDEPEND="virtual/jdk:1.8
	~dev-java/netbeans-extide-${PV}
	~dev-java/netbeans-ide-${PV}
	~dev-java/netbeans-platform-${PV}
	~dev-java/netbeans-webcommon-${PV}
	~dev-java/netbeans-websvccommon-${PV}
	dev-java/javacup:0"
DEPEND="${CDEPEND}
	app-arch/unzip
	dev-java/javahelp:0"
RDEPEND="${CDEPEND}"

INSTALL_DIR="/usr/share/${PN}-${SLOT}"

EANT_BUILD_XML="nbbuild/build.xml"
EANT_BUILD_TARGET="rebuild-cluster"
EANT_EXTRA_ARGS="-Drebuild.cluster.name=nb.cluster.php -Dext.binaries.downloaded=true -Dpermit.jdk8.builds=true"
EANT_FILTER_COMPILER="ecj-3.3 ecj-3.4 ecj-3.5 ecj-3.6 ecj-3.7"
JAVA_PKG_BSFIX="off"

src_unpack() {
	unpack $(basename ${SOURCE_URL})

	einfo "Deleting bundled jars..."
	find -name "*.jar" -type f -delete

	unpack netbeans-8.2-build.xml.patch.bz2

	pushd "${S}" >/dev/null || die
	ln -s "${DISTDIR}"/0702230EB3354A1687E4496D73A94F33A1E343BD-phpdocdesc.zip php.phpdoc.documentation/external/phpdocdesc.zip || die
	ln -s "${DISTDIR}"/472A52636BE09823B4E5F707071B31FB990A7375-phpsigfiles.zip php.project/external/phpsigfiles.zip || die
	ln -s "${DISTDIR}"/3D6AF75EA20D715887DAF47A3F063864EF0814C1-predefined_vars.zip php.editor/external/predefined_vars.zip || die
	popd >/dev/null || die
}

src_prepare() {
	einfo "Deleting bundled class files..."
	find -name "*.class" -type f | xargs rm -vf

	epatch netbeans-8.2-build.xml.patch

	einfo "Symlinking external libraries..."
	java-pkg_jar-from --build-only --into javahelp/external javahelp jhall.jar jhall-2.0_05.jar
	java-pkg_jar-from --into libs.javacup/external javacup javacup.jar java-cup-11a.jar

	einfo "Linking in other clusters..."
	mkdir "${S}"/nbbuild/netbeans || die
	pushd "${S}"/nbbuild/netbeans >/dev/null || die

	ln -s /usr/share/netbeans-extide-${SLOT} extide || die
	cat /usr/share/netbeans-extide-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.extide.built

	ln -s /usr/share/netbeans-ide-${SLOT} ide || die
	cat /usr/share/netbeans-ide-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.ide.built

	ln -s /usr/share/netbeans-platform-${SLOT} platform || die
	cat /usr/share/netbeans-platform-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.platform.built

	ln -s /usr/share/netbeans-webcommon-${SLOT} webcommon || die
	cat /usr/share/netbeans-webcommon-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.webcommon.built

	ln -s /usr/share/netbeans-websvccommon-${SLOT} websvccommon || die
	cat /usr/share/netbeans-websvccommon-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.websvccommon.built

	popd >/dev/null || die

	java-pkg-2_src_prepare
	default
}

src_install() {
	pushd nbbuild/netbeans/php >/dev/null || die

	insinto ${INSTALL_DIR}

	grep -E "/php$" ../moduleCluster.properties > "${D}"/${INSTALL_DIR}/moduleCluster.properties || die

	doins -r *

	popd >/dev/null || die

	local instdir="${D}"/${INSTALL_DIR}/modules/ext
	pushd "${instdir}" >/dev/null || die
	rm java-cup-11a.jar && java-pkg_jar-from --into "${instdir}" javacup javacup.jar java-cup-11a.jar
	popd >/dev/null || die

	dosym ${INSTALL_DIR} /usr/share/netbeans-nb-${SLOT}/php
}
