# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Netbeans JavaDocs"
HOMEPAGE="http://netbeans.org/"
SLOT="8.2"
SOURCE_URL="http://download.netbeans.org/netbeans/8.2/final/zip/netbeans-8.2-201609300101-src.zip"
SRC_URI="${SOURCE_URL}
	https://dev.gentoo.org/~fordfrog/distfiles/netbeans-8.2-build.xml.patch.bz2
	http://hg.netbeans.org/binaries/BEA15848D713D491C6EBA1307E0564A5BC3965E7-ant-libs-1.9.7.zip"
LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
KEYWORDS="amd64 ~x86"
IUSE=""
S="${WORKDIR}"

# oracle-jdk-bin is needed because of javafx which is not currently packaged separately
DEPEND="dev-java/oracle-jdk-bin:1.8[javafx]
	app-arch/unzip
	dev-java/javahelp:0
	dev-java/junit:4
	~dev-java/netbeans-apisupport-${PV}
	~dev-java/netbeans-cnd-${PV}
	~dev-java/netbeans-dlight-${PV}
	~dev-java/netbeans-enterprise-${PV}
	~dev-java/netbeans-ergonomics-${PV}
	~dev-java/netbeans-extide-${PV}
	~dev-java/netbeans-groovy-${PV}
	~dev-java/netbeans-harness-${PV}
	~dev-java/netbeans-ide-${PV}
	~dev-java/netbeans-java-${PV}
	~dev-java/netbeans-javacard-${PV}
	~dev-java/netbeans-mobility-${PV}
	~dev-java/netbeans-nb-${PV}
	~dev-java/netbeans-php-${PV}
	~dev-java/netbeans-platform-${PV}
	~dev-java/netbeans-profiler-${PV}
	~dev-java/netbeans-websvccommon-${PV}"
RDEPEND=""

JAVA_PKG_BSFIX="off"
JAVA_PKG_WANT_BUILD_VM="oracle-jdk-bin-1.8"
JAVA_PKG_WANT_SOURCE="1.7"
JAVA_PKG_WANT_TARGET="1.7"

src_unpack() {
	unpack $(basename ${SOURCE_URL})

	einfo "Deleting bundled jars..."
	find -name "*.jar" -type f -delete

	unpack netbeans-8.2-build.xml.patch.bz2

	pushd "${S}" >/dev/null || die
	ln -s "${DISTDIR}"/BEA15848D713D491C6EBA1307E0564A5BC3965E7-ant-libs-1.9.7.zip o.apache.tools.ant.module/external/ant-libs-1.9.7.zip || die
	popd >/dev/null || die
}

src_prepare() {
	einfo "Deleting bundled class files..."
	find -name "*.class" -type f | xargs rm -vf

	epatch netbeans-8.2-build.xml.patch

	einfo "Symlinking external libraries..."
	java-pkg_jar-from --build-only --into javahelp/external javahelp jhall.jar jhall-2.0_05.jar
	java-pkg_jar-from --build-only --into libs.junit4/external junit-4 junit.jar junit-4.12.jar

	einfo "Linking in other clusters..."
	mkdir "${S}"/nbbuild/netbeans || die
	pushd "${S}"/nbbuild/netbeans >/dev/null || die

	ln -s /usr/share/netbeans-apisupport-${SLOT} apisupport || die
	cat /usr/share/netbeans-apisupport-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.apisupport.built

	ln -s /usr/share/netbeans-cnd-${SLOT} cnd || die
	cat /usr/share/netbeans-cnd-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.cnd.built

	ln -s /usr/share/netbeans-dlight-${SLOT} dlight || die
	cat /usr/share/netbeans-dlight-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.dlight.built

	ln -s /usr/share/netbeans-enterprise-${SLOT} enterprise || die
	cat /usr/share/netbeans-enterprise-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.enterprise.built

	ln -s /usr/share/netbeans-ergonomics-${SLOT} ergonomics || die
	cat /usr/share/netbeans-ergonomics-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.ergonomics.built

	ln -s /usr/share/netbeans-extide-${SLOT} extide || die
	cat /usr/share/netbeans-extide-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.extide.built

	ln -s /usr/share/netbeans-groovy-${SLOT} groovy || die
	cat /usr/share/netbeans-groovy-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.groovy.built

	ln -s /usr/share/netbeans-harness-${SLOT} harness || die
	cat /usr/share/netbeans-harness-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.harness.built

	ln -s /usr/share/netbeans-ide-${SLOT} ide || die
	cat /usr/share/netbeans-ide-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.ide.built

	ln -s /usr/share/netbeans-java-${SLOT} java || die
	cat /usr/share/netbeans-java-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.java.built

	ln -s /usr/share/netbeans-javacard-${SLOT} javacard || die
	cat /usr/share/netbeans-javacard-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.javacard.built

	ln -s /usr/share/netbeans-mobility-${SLOT} mobility || die
	cat /usr/share/netbeans-mobility-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.mobility.built

	ln -s /usr/share/netbeans-nb-${SLOT}/nb nb || die
	cat /usr/share/netbeans-nb-${SLOT}/nb/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.nb.built

	ln -s /usr/share/netbeans-php-${SLOT} php || die
	cat /usr/share/netbeans-php-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.php.built

	ln -s /usr/share/netbeans-platform-${SLOT} platform || die
	cat /usr/share/netbeans-platform-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.platform.built

	ln -s /usr/share/netbeans-profiler-${SLOT} profiler || die
	cat /usr/share/netbeans-profiler-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.profiler.built

	ln -s /usr/share/netbeans-websvccommon-${SLOT} websvccommon || die
	cat /usr/share/netbeans-websvccommon-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.websvccommon.built

	java-pkg-2_src_prepare
	default
}

src_compile() {
	eant -Dpermit.jdk8.builds=true -f nbbuild/build.xml bootstrap || die
	ANT_OPTS="-Xmx1536m" eant -Dpermit.jdk8.builds=true -f nbbuild/javadoctools/build.xml build-javadoc
}

src_install() {
	rm nbbuild/build/javadoc/*.zip
	java-pkg_dojavadoc nbbuild/build/javadoc
}
