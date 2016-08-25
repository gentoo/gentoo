# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit eutils java-pkg-2 java-ant-2

# Maven cannot be unbundled because it depends on exact maven version and exact content of maven directory

DESCRIPTION="Netbeans Java Cluster"
HOMEPAGE="http://netbeans.org/projects/java"
SLOT="8.0"
SOURCE_URL="http://download.netbeans.org/netbeans/8.0.2/final/zip/netbeans-8.0.2-201411181905-src.zip"
SRC_URI="${SOURCE_URL}
	https://dev.gentoo.org/~fordfrog/distfiles/netbeans-8.0.2-build.xml.patch.bz2
	http://hg.netbeans.org/binaries/694F57282D92C434800F79218E64704E5947008A-apache-maven-3.0.5-bin.zip
	http://hg.netbeans.org/binaries/F7BD95641780C2AAE8CB9BED1686441A1CE5E749-beansbinding-1.2.1-doc.zip
	http://hg.netbeans.org/binaries/CD2211635F3011E300CA8FEDC1CE0E1CF61C175B-eclipselink.jar
	http://hg.netbeans.org/binaries/A9A0648BD7D9FD2CDFBD22C25366E71DA72438DA-hibernate-release-4.3.1-lib.zip
	http://hg.netbeans.org/binaries/562F0CFA47F0636EBB5A544968EE7A692FC5D26D-indexer-artifact-5.1.1.jar
	http://hg.netbeans.org/binaries/2B9EAB164D8748F9793F6A0D29B6463E97B284DA-indexer-core-5.1.1.jar
	http://hg.netbeans.org/binaries/D87F53C99E4CD88F5416EDD5ABB77F2A1CCFB050-jarjar-1.4.jar
	http://hg.netbeans.org/binaries/5BAB675816DBE0F64BB86004B108BF2A00292358-javax.persistence_2.1.0.v201304241213.jar
	http://hg.netbeans.org/binaries/84E2020E5499015E9F40D1212C86918264B89EB1-jaxws-2.2.6.zip
	http://hg.netbeans.org/binaries/D64C40E770C95C2A6994081C00CCD489C0AA20C9-jaxws-2.2.6-api.zip
	http://hg.netbeans.org/binaries/8ECD169E9E308C258287E4F28B03B6D6F1E55F47-jaxws-api-doc.zip
	http://hg.netbeans.org/binaries/A8BD39C5B88571B4D4697E78DD1A56566E44B1DD-JPAjavadocs04032013.zip
	http://hg.netbeans.org/binaries/9EC77E2507F9CC01756964C71D91EFD8154A8C47-lucene-core-3.6.2.jar
	http://hg.netbeans.org/binaries/A90682C6BC0B9E105BD260C9A041FEFEA9579E46-lucene-highlighter-3.6.2.jar
	http://hg.netbeans.org/binaries/BF206C4AA93C74A739FBAF1F1C78E3AD5F167245-maven-dependency-tree-2.0.jar
	http://hg.netbeans.org/binaries/E5579EF3B0C1EF2F43562DD0C3B32F8E1F603B49-nb-javac-api.jar
	http://hg.netbeans.org/binaries/8BDE88C9512D8783E64788F32A50E4CCBC48485E-nb-javac-impl.jar
	http://hg.netbeans.org/binaries/29AF1D338CBB76290D1A96F5A6610F1E8C319AE5-org.eclipse.persistence.jpa.jpql_2.5.2.v20140319-9ad6abd.jar
	http://hg.netbeans.org/binaries/3CE04BDB48FE315736B1DCE407362C57DFAE286D-org.eclipse.persistence.jpa.modelgen_2.5.2.v20140319-9ad6abd.jar
	http://hg.netbeans.org/binaries/7666B94C1004AFFFE88E5328BD70EBA6F60125F4-spring-framework-3.2.7.RELEASE.zip
	http://hg.netbeans.org/binaries/91B55CDAC59BC4DDDF0AF9A54EAAE4304EDEF266-spring-framework-4.0.1.RELEASE.zip"
LICENSE="|| ( CDDL GPL-2-with-classpath-exception )"
KEYWORDS="amd64 x86"
IUSE=""
S="${WORKDIR}"

CDEPEND="~dev-java/netbeans-platform-${PV}
	~dev-java/netbeans-extide-${PV}
	~dev-java/netbeans-harness-${PV}
	~dev-java/netbeans-ide-${PV}
	~dev-java/netbeans-websvccommon-${PV}
	dev-java/beansbinding:0
	dev-java/cglib:3
	dev-java/jdom:0"
DEPEND="virtual/jdk:1.7
	app-arch/unzip
	${CDEPEND}
	dev-java/javahelp:0
	dev-java/json-simple:0
	dev-java/junit:4"
RDEPEND=">=virtual/jdk-1.7
	${CDEPEND}
	dev-java/absolutelayout:0
	dev-java/antlr:0[java(+)]
	dev-java/c3p0:0
	dev-java/commons-collections:0
	dev-java/dom4j:1
	dev-java/fastinfoset:0
	dev-java/glassfish-transaction-api:0
	dev-java/javassist:3
	dev-java/jboss-logging:0
	dev-java/jsr67:0
	dev-java/jsr181:0
	>=dev-java/jtidy-1:0
	dev-java/log4j:0
	dev-java/mimepull:0
	dev-java/saaj:0
	dev-java/stax-ex:0
	dev-java/xmlstreambuffer:0"

INSTALL_DIR="/usr/share/${PN}-${SLOT}"

EANT_BUILD_XML="nbbuild/build.xml"
EANT_BUILD_TARGET="rebuild-cluster"
EANT_EXTRA_ARGS="-Drebuild.cluster.name=nb.cluster.java -Dext.binaries.downloaded=true"
EANT_FILTER_COMPILER="ecj-3.3 ecj-3.4 ecj-3.5 ecj-3.6 ecj-3.7"
JAVA_PKG_BSFIX="off"

pkg_pretend() {
	local die_now=""

	if [ -d /usr/share/netbeans-java-${SLOT}/ant ]; then
		if [ -n "$(find /usr/share/netbeans-java-${SLOT}/ant -type l)" ]; then
			eerror "Please remove following symlinks and run emerge again:"
			find /usr/share/netbeans-java-${SLOT}/ant -type l
			die_now="1"
		fi
	fi

	if [ -L /usr/share/netbeans-java-${SLOT}/maven ]; then
		if [ -z "${die_now}" ]; then
			eerror "Please remove following symlinks and run emerge again:"
		fi

		echo "/usr/share/netbeans-java-${SLOT}/maven"
		die_now="1"
	fi

	if [ -n "${die_now}" ]; then
		die "Symlinks exist"
	fi
}

src_unpack() {
	unpack $(basename ${SOURCE_URL})

	einfo "Deleting bundled jars..."
	find -name "*.jar" -type f -delete

	unpack netbeans-8.0.2-build.xml.patch.bz2

	pushd "${S}" >/dev/null || die
	ln -s "${DISTDIR}"/694F57282D92C434800F79218E64704E5947008A-apache-maven-3.0.5-bin.zip maven.embedder/external/apache-maven-3.0.5-bin.zip || die
	ln -s "${DISTDIR}"/F7BD95641780C2AAE8CB9BED1686441A1CE5E749-beansbinding-1.2.1-doc.zip o.jdesktop.beansbinding/external/beansbinding-1.2.1-doc.zip || die
	ln -s "${DISTDIR}"/CD2211635F3011E300CA8FEDC1CE0E1CF61C175B-eclipselink.jar j2ee.eclipselink/external/eclipselink.jar || die
	ln -s "${DISTDIR}"/A9A0648BD7D9FD2CDFBD22C25366E71DA72438DA-hibernate-release-4.3.1-lib.zip hibernate4lib/external/hibernate-release-4.3.1-lib.zip || die
	ln -s "${DISTDIR}"/562F0CFA47F0636EBB5A544968EE7A692FC5D26D-indexer-artifact-5.1.1.jar maven.indexer/external/indexer-artifact-5.1.1.jar || die
	ln -s "${DISTDIR}"/2B9EAB164D8748F9793F6A0D29B6463E97B284DA-indexer-core-5.1.1.jar maven.indexer/external/indexer-core-5.1.1.jar || die
	ln -s "${DISTDIR}"/D87F53C99E4CD88F5416EDD5ABB77F2A1CCFB050-jarjar-1.4.jar maven/external/jarjar-1.4.jar || die
	ln -s "${DISTDIR}"/5BAB675816DBE0F64BB86004B108BF2A00292358-javax.persistence_2.1.0.v201304241213.jar j2ee.eclipselink/external/javax.persistence_2.1.0.v201304241213.jar || die
	ln -s "${DISTDIR}"/84E2020E5499015E9F40D1212C86918264B89EB1-jaxws-2.2.6.zip websvc.jaxws21/external/jaxws-2.2.6.zip || die
	ln -s "${DISTDIR}"/D64C40E770C95C2A6994081C00CCD489C0AA20C9-jaxws-2.2.6-api.zip websvc.jaxws21api/external/jaxws-2.2.6-api.zip || die
	ln -s "${DISTDIR}"/8ECD169E9E308C258287E4F28B03B6D6F1E55F47-jaxws-api-doc.zip websvc.jaxws21/external/jaxws-api-doc.zip || die
	ln -s "${DISTDIR}"/A8BD39C5B88571B4D4697E78DD1A56566E44B1DD-JPAjavadocs04032013.zip j2ee.eclipselink/external/JPAjavadocs04032013.zip || die
	ln -s "${DISTDIR}"/9EC77E2507F9CC01756964C71D91EFD8154A8C47-lucene-core-3.6.2.jar maven.indexer/external/lucene-core-3.6.2.jar || die
	ln -s "${DISTDIR}"/A90682C6BC0B9E105BD260C9A041FEFEA9579E46-lucene-highlighter-3.6.2.jar maven.indexer/external/lucene-highlighter-3.6.2.jar || die
	ln -s "${DISTDIR}"/BF206C4AA93C74A739FBAF1F1C78E3AD5F167245-maven-dependency-tree-2.0.jar maven.embedder/external/maven-dependency-tree-2.0.jar || die
	ln -s "${DISTDIR}"/E5579EF3B0C1EF2F43562DD0C3B32F8E1F603B49-nb-javac-api.jar libs.javacapi/external/nb-javac-api.jar || die
	ln -s "${DISTDIR}"/8BDE88C9512D8783E64788F32A50E4CCBC48485E-nb-javac-impl.jar libs.javacimpl/external/nb-javac-impl.jar || die
	ln -s "${DISTDIR}"/29AF1D338CBB76290D1A96F5A6610F1E8C319AE5-org.eclipse.persistence.jpa.jpql_2.5.2.v20140319-9ad6abd.jar j2ee.eclipselink/external/org.eclipse.persistence.jpa.jpql_2.5.2.v20140319-9ad6abd.jar || die
	ln -s "${DISTDIR}"/3CE04BDB48FE315736B1DCE407362C57DFAE286D-org.eclipse.persistence.jpa.modelgen_2.5.2.v20140319-9ad6abd.jar j2ee.eclipselinkmodelgen/external/org.eclipse.persistence.jpa.modelgen_2.5.2.v20140319-9ad6abd.jar || die
	ln -s "${DISTDIR}"/7666B94C1004AFFFE88E5328BD70EBA6F60125F4-spring-framework-3.2.7.RELEASE.zip libs.springframework/external/spring-framework-3.2.7.RELEASE.zip || die
	ln -s "${DISTDIR}"/91B55CDAC59BC4DDDF0AF9A54EAAE4304EDEF266-spring-framework-4.0.1.RELEASE.zip libs.springframework/external/spring-framework-4.0.1.RELEASE.zip || die
	popd >/dev/null || die
}

src_prepare() {
	einfo "Deleting bundled class files..."
	find -name "*.class" -type f | xargs rm -vf

	epatch netbeans-8.0.2-build.xml.patch

	# Support for custom patches
	if [ -n "${NETBEANS80_PATCHES_DIR}" -a -d "${NETBEANS80_PATCHES_DIR}" ] ; then
		local files=`find "${NETBEANS80_PATCHES_DIR}" -type f`

		if [ -n "${files}" ] ; then
			einfo "Applying custom patches:"

			for file in ${files} ; do
				epatch "${file}"
			done
		fi
	fi

	einfo "Symlinking external libraries..."
	java-pkg_jar-from --build-only --into javahelp/external javahelp jhall.jar jhall-2.0_05.jar
	java-pkg_jar-from --into libs.cglib/external cglib-3 cglib.jar cglib-2.2.jar
	java-pkg_jar-from --build-only --into libs.json_simple/external json-simple json-simple.jar json-simple-1.1.1.jar
	java-pkg_jar-from --build-only --into libs.junit4/external junit-4 junit.jar junit-4.10.jar
	java-pkg_jar-from --into maven.embedder/external jdom jdom.jar jdom-1.0.jar
	java-pkg_jar-from --into o.jdesktop.beansbinding/external beansbinding beansbinding.jar beansbinding-1.2.1.jar

	einfo "Linking in other clusters..."
	mkdir "${S}"/nbbuild/netbeans || die
	pushd "${S}"/nbbuild/netbeans >/dev/null || die

	ln -s /usr/share/netbeans-platform-${SLOT} platform || die
	cat /usr/share/netbeans-platform-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.platform.built

	ln -s /usr/share/netbeans-extide-${SLOT} extide || die
	cat /usr/share/netbeans-extide-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.extide.built

	ln -s /usr/share/netbeans-harness-${SLOT} harness || die
	cat /usr/share/netbeans-harness-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.harness.built

	ln -s /usr/share/netbeans-ide-${SLOT} ide || die
	cat /usr/share/netbeans-ide-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.ide.built

	ln -s /usr/share/netbeans-websvccommon-${SLOT} websvccommon || die
	cat /usr/share/netbeans-websvccommon-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.websvccommon.built

	popd >/dev/null || die

	java-pkg-2_src_prepare
}

src_install() {
	pushd nbbuild/netbeans/java >/dev/null || die

	insinto ${INSTALL_DIR}
	grep -E "/java$" ../moduleCluster.properties > "${D}"/${INSTALL_DIR}/moduleCluster.properties || die

	doins -r *
	chmod 755 "${D}"/${INSTALL_DIR}/maven/bin/mvn* || die
	rm -fr "${D}"/${INSTALL_DIR}/maven/bin/*.bat || die

	popd >/dev/null || die

	local instdir=/${INSTALL_DIR}/modules/ext
	pushd "${D}"/${instdir} >/dev/null || die
	rm AbsoluteLayout.jar  && dosym /usr/share/absolutelayout/lib/absolutelayout.jar ${instdir}/AbsoluteLayout.jar || die
	rm beansbinding-1.2.1.jar && dosym /usr/share/beansbinding/lib/beansbinding.jar ${instdir}/beansbinding-1.2.1.jar || die
	rm cglib-2.2.jar && dosym /usr/share/cglib-3/lib/cglib.jar ${instdir}/cglib-2.2.jar || die
	popd >/dev/null || die

	local instdir=${INSTALL_DIR}/modules/ext/hibernate4
	local dinstdir="${D}/${instdir}"
	pushd "${D}"/${instdir} >/dev/null || die
	rm antlr-2.7.7.jar && dosym /usr/share/antlr/lib/antlr.jar ${instdir}/antlr-2.7.7.jar || die
	rm c3p0-0.9.2.1.jar && dosym /usr/share/c3p0/lib/c3p0.jar ${instdir}/c3p0-0.9.2.1.jar || die
	rm cglib-2.2.jar && dosym /usr/share/cglib-3/lib/cglib.jar ${instdir}/cglib-2.2.jar || die
	rm commons-collections-3.2.1.jar && dosym /usr/share/commons-collections/lib/commons-collections.jar ${instdir}/commons-collections-3.2.1.jar || die
	rm dom4j-1.6.1.jar && dosym /usr/share/dom4j-1/lib/dom4j.jar ${instdir}/dom4j-1.6.1.jar || die
	rm javassist-3.18.1-GA.jar && dosym /usr/share/javassist-3/lib/javassist.jar ${instdir}/javassist-3.18.1-GA.jar || die
	rm jboss-logging-3.1.3.GA.jar && dosym /usr/share/jboss-logging/lib/jboss-logging.jar ${instdir}/jboss-logging-3.1.3.GA.jar || die
	rm jboss-transaction-api_1.2_spec-1.0.0.Final.jar && dosym /usr/share/glassfish-transaction-api/lib/jta.jar ${instdir}/jboss-transaction-api_1.2_spec-1.0.0.Final.jar || die
	rm jtidy-r8-20060801.jar && java-pkg_jar-from --into "${dinstdir}" jtidy jtidy.jar jtidy-r8-20060801.jar
	rm log4j-1.2.12.jar && dosym /usr/share/log4j/lib/log4j.jar ${instdir}/log4j-1.2.12.jar || die
	popd >/dev/null || die

	local instdir=/${INSTALL_DIR}/modules/ext/jaxws22
	pushd "${D}"/${instdir} >/dev/null || die
	rm FastInfoset.jar && dosym /usr/share/fastinfoset/lib/fastinfoset.jar ${instdir}/FastInfoset.jar || die
	rm mimepull.jar && dosym /usr/share/mimepull/lib/mimepull.jar ${instdir}/mimepull.jar || die
	rm saaj-impl.jar && dosym /usr/share/saaj/lib/saaj.jar ${instdir}/saaj-impl.jar || die
	rm stax-ex.jar && dosym /usr/share/stax-ex/lib/stax-ex.jar ${instdir}/stax-ex.jar || die
	rm streambuffer.jar && dosym /usr/share/xmlstreambuffer/lib/xmlstreambuffer.jar ${instdir}/streambuffer.jar || die
	popd >/dev/null || die

	local instdir=${INSTALL_DIR}/modules/ext/jaxws22/api
	pushd "${D}"/${instdir} >/dev/null || die
	rm jsr181-api.jar && dosym /usr/share/jsr181/lib/jsr181.jar ${instdir}/jsr181-api.jar || die
	rm saaj-api.jar && dosym /usr/share/jsr67/lib/jsr67.jar ${instdir}/saaj-api.jar || die
	popd >/dev/null || die

	local instdir=${INSTALL_DIR}/modules/ext/maven
	pushd "${D}"/${instdir} >/dev/null || die
	rm jdom-1.0.jar && dosym /usr/share/jdom/lib/jdom.jar ${instdir}/jdom-1.0.jar || die
	popd >/dev/null || die

	dosym ${INSTALL_DIR} /usr/share/netbeans-nb-${SLOT}/java
}
