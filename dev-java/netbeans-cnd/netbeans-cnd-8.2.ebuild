# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Netbeans CND Cluster"
HOMEPAGE="http://netbeans.org/projects/cnd"
SLOT="8.2"
SOURCE_URL="http://download.netbeans.org/netbeans/8.2/final/zip/netbeans-8.2-201609300101-src.zip"
SRC_URI="${SOURCE_URL}
	http://dev.gentoo.org/~fordfrog/distfiles/netbeans-8.2-build.xml.patch.bz2
	http://hg.netbeans.org/binaries/5CAB59D859CAA6598E28131D30DD2E89806DB57F-antlr-3.4.jar
	http://hg.netbeans.org/binaries/4E74C6BE42FE89871A878C7C4D6158F21A6D8010-antlr-runtime-3.4.jar
	http://hg.netbeans.org/binaries/F20EEEDF4FE6B93B180387576FB780EED9F79C66-clank_0.3.9.zip
	http://hg.netbeans.org/binaries/43A82EB3CE61B9B0B1C60586C7D84729BD5BE3E0-cnd-build-trace-1.0.zip
	http://hg.netbeans.org/binaries/E59851B0E49C05D728D5C653E52750FA5B6A8F0E-cnd-rfs-1.0.zip
	http://hg.netbeans.org/binaries/C51780D99464CBF45B0495C7646B442AB3C7B463-open-fortran-parser-0.7.1.2.zip"
LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}"

# These files are for remote development and debugging
QA_PREBUILT="usr/share/netbeans-cnd-${SLOT}/bin/*"

CDEPEND="~dev-java/netbeans-dlight-${PV}
	~dev-java/netbeans-harness-${PV}
	~dev-java/netbeans-ide-${PV}
	~dev-java/netbeans-platform-${PV}"
DEPEND=">=virtual/jdk-1.7
	app-arch/unzip
	>=dev-java/jna-3.4.0
	${CDEPEND}
	dev-java/javahelp:0"
RDEPEND="|| ( virtual/jdk:1.7 virtual/jdk:1.8 )
	${CDEPEND}"

INSTALL_DIR="/usr/share/${PN}-${SLOT}"

EANT_BUILD_XML="nbbuild/build.xml"
EANT_BUILD_TARGET="rebuild-cluster"
EANT_EXTRA_ARGS="-Drebuild.cluster.name=nb.cluster.cnd -Dext.binaries.downloaded=true -Dpermit.jdk8.builds=true"
EANT_FILTER_COMPILER="ecj-3.3 ecj-3.4 ecj-3.5 ecj-3.6 ecj-3.7"
JAVA_PKG_BSFIX="off"

src_unpack() {
	unpack $(basename ${SOURCE_URL})

	einfo "Deleting bundled jars..."
	find -name "*.jar" -type f -delete

	unpack netbeans-8.2-build.xml.patch.bz2

	pushd "${S}" >/dev/null || die
	ln -s "${DISTDIR}"/5CAB59D859CAA6598E28131D30DD2E89806DB57F-antlr-3.4.jar libs.antlr3.devel/external/antlr-3.4.jar || die
	ln -s "${DISTDIR}"/4E74C6BE42FE89871A878C7C4D6158F21A6D8010-antlr-runtime-3.4.jar libs.antlr3.runtime/external/antlr-runtime-3.4.jar || die
	ln -s "${DISTDIR}"/F20EEEDF4FE6B93B180387576FB780EED9F79C66-clank_0.3.9.zip libs.clank/external/clank_0.3.9.zip || die
	ln -s "${DISTDIR}"/43A82EB3CE61B9B0B1C60586C7D84729BD5BE3E0-cnd-build-trace-1.0.zip cnd.discovery/external/cnd-build-trace-1.0.zip || die
	ln -s "${DISTDIR}"/E59851B0E49C05D728D5C653E52750FA5B6A8F0E-cnd-rfs-1.0.zip cnd.remote/external/cnd-rfs-1.0.zip || die
	ln -s "${DISTDIR}"/C51780D99464CBF45B0495C7646B442AB3C7B463-open-fortran-parser-0.7.1.2.zip cnd.modelimpl/external/open-fortran-parser-0.7.1.2.zip || die
	popd >/dev/null || die
}

src_prepare() {
	einfo "Deleting bundled class files..."
	find -name "*.class" -type f | xargs rm -vf

	epatch netbeans-8.2-build.xml.patch

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
	java-pkg_jar-from --build-only --into javahelp/external javahelp jhall.jar jhall-2.0_05.jar
	java-pkg_jar-from --build-only --into libs.jna/external jna jna.jar jna-4.2.2.jar

	einfo "Linking in other clusters..."
	mkdir "${S}"/nbbuild/netbeans || die
	pushd "${S}"/nbbuild/netbeans >/dev/null || die

	ln -s /usr/share/netbeans-dlight-${SLOT} dlight || die
	cat /usr/share/netbeans-dlight-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.dlight.built

	ln -s /usr/share/netbeans-harness-${SLOT} harness || die
	cat /usr/share/netbeans-harness-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.harness.built

	ln -s /usr/share/netbeans-ide-${SLOT} ide || die
	cat /usr/share/netbeans-ide-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.ide.built

	ln -s /usr/share/netbeans-platform-${SLOT} platform || die
	cat /usr/share/netbeans-platform-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.platform.built

	popd >/dev/null || die

	java-pkg-2_src_prepare
}

src_install() {
	pushd nbbuild/netbeans/cnd >/dev/null || die

	insinto ${INSTALL_DIR}

	grep -E "/cnd$" ../moduleCluster.properties > "${D}"/${INSTALL_DIR}/moduleCluster.properties || die

	doins -r *
	fperms 755 bin/dorun.sh

	popd >/dev/null || die

	dosym ${INSTALL_DIR} /usr/share/netbeans-nb-${SLOT}/cnd
}
