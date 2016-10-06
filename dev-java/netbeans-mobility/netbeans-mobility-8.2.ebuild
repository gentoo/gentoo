# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Netbeans Mobility Cluster"
HOMEPAGE="http://netbeans.org/features/platform/"
SLOT="8.2"
SOURCE_URL="http://download.netbeans.org/netbeans/8.2/final/zip/netbeans-8.2-201609300101-src.zip"
SRC_URI="${SOURCE_URL}
	http://dev.gentoo.org/~fordfrog/distfiles/netbeans-8.2-build.xml.patch.bz2"
LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}"

CDEPEND="~dev-java/netbeans-apisupport-${PV}
	~dev-java/netbeans-enterprise-${PV}
	~dev-java/netbeans-extide-${PV}
	~dev-java/netbeans-ide-${PV}
	~dev-java/netbeans-java-${PV}
	~dev-java/netbeans-platform-${PV}
	~dev-java/netbeans-websvccommon-${PV}"
DEPEND=">=virtual/jdk-1.7
	app-arch/unzip
	${CDEPEND}
	dev-java/javahelp:0"
RDEPEND="|| ( virtual/jdk:1.7 virtual/jdk:1.8 )
	${CDEPEND}"

INSTALL_DIR="/usr/share/${PN}-${SLOT}"

EANT_BUILD_XML="nbbuild/build.xml"
EANT_BUILD_TARGET="rebuild-cluster"
EANT_EXTRA_ARGS="-Drebuild.cluster.name=nb.cluster.mobility -Dext.binaries.downloaded=true -Dpermit.jdk8.builds=true"
EANT_FILTER_COMPILER="ecj-3.3 ecj-3.4 ecj-3.5 ecj-3.6 ecj-3.7"
JAVA_PKG_BSFIX="off"

src_unpack() {
	unpack $(basename ${SOURCE_URL})

	einfo "Deleting bundled jars..."
	find -name "*.jar" -type f | grep -vE "mobility.databindingme/lib/netbeans_databindingme.*\.jar" \
		| grep -v "vmd.components.midp/netbeans_midp_components_basic/dist/netbeans_midp_components_basic.jar" \
		| grep -v "vmd.components.midp.pda/netbeans_midp_components_pda/dist/netbeans_midp_components_pda.jar" \
		| grep -v "vmd.components.midp.wma/netbeans_midp_components_wma/dist/netbeans_midp_components_wma.jar" \
		| grep -v "vmd.components.svg/nb_svg_midp_components/dist/nb_svg_midp_components.jar" | xargs rm

	unpack netbeans-8.2-build.xml.patch.bz2
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

	einfo "Linking in other clusters..."
	mkdir "${S}"/nbbuild/netbeans || die
	pushd "${S}"/nbbuild/netbeans >/dev/null || die

	ln -s /usr/share/netbeans-apisupport-${SLOT} apisupport || die
	cat /usr/share/netbeans-apisupport-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.apisupport.built

	ln -s /usr/share/netbeans-enterprise-${SLOT} enterprise || die
	cat /usr/share/netbeans-enterprise-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.enterprise.built

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

	ln -s /usr/share/netbeans-websvccommon-${SLOT} websvccommon || die
	cat /usr/share/netbeans-websvccommon-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.websvccommon.built

	popd >/dev/null || die

	java-pkg-2_src_prepare
}

src_install() {
	pushd nbbuild/netbeans/mobility >/dev/null || die

	insinto ${INSTALL_DIR}

	grep -E "/mobility$" ../moduleCluster.properties > "${D}"/${INSTALL_DIR}/moduleCluster.properties || die

	doins -r *
	rm -rf "${D}"/${INSTALL_DIR}/modules/lib || die

	popd >/dev/null || die

	dosym ${INSTALL_DIR} /usr/share/netbeans-nb-${SLOT}/mobility
}
