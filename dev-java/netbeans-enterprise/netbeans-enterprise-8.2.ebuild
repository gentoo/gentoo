# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Netbeans Enterprise cluster"
HOMEPAGE="http://netbeans.org/"
SLOT="8.2"
SOURCE_URL="http://download.netbeans.org/netbeans/8.2/final/zip/netbeans-8.2-201609300101-src.zip"
SRC_URI="${SOURCE_URL}
	http://dev.gentoo.org/~fordfrog/distfiles/netbeans-8.2-build.xml.patch.bz2
	http://hg.netbeans.org/binaries/8BFEBCD4B39B87BBE788B4EECED068C8DBE75822-aws-java-sdk-1.2.1.jar
	http://hg.netbeans.org/binaries/BA8A45A96AFE07D914DE153E0BB137DCDC7734F6-el-impl.jar
	http://hg.netbeans.org/binaries/33B0D0945555A06B74931DEACF9DB1A4AE2A3EC4-glassfish-jspparser-4.0.jar
	http://hg.netbeans.org/binaries/D813E05A06B587CD0FE36B00442EAB03C1431AA9-glassfish-logging-2.0.jar
	http://hg.netbeans.org/binaries/3D74BFB229C259E2398F2B383D5425CB81C643F0-httpclient-4.1.1.jar
	http://hg.netbeans.org/binaries/33FC26C02F8043AB0EDE19EADC8C9885386B255C-httpcore-4.1.jar
	http://hg.netbeans.org/binaries/D6F416983EA13C334D5C599A9045414ECAF5D66D-javaee-api-6.0.jar
	http://hg.netbeans.org/binaries/51399F902CC27A808122EDCBEBFAA1AD989954BA-javaee-api-7.0.jar
	http://hg.netbeans.org/binaries/EBEC44255251E6D3B8DDBAF701F732DAF0238CBF-javaee-web-api-6.0.jar
	http://hg.netbeans.org/binaries/B1FCE45BA94108EBF7E1CACE6427EC8761CABEC1-javaee-web-api-7.0.jar
	http://hg.netbeans.org/binaries/27E9711AA35C39EF455BFD900D544BACB99C0E89-javaee-doc-api.jar
	http://hg.netbeans.org/binaries/B290091E71DEED6CE7F9EB40523D49C26399A2B4-javax.annotation.jar
	http://hg.netbeans.org/binaries/1DEEA980904E39C3D7AA240B72CDBBEB8E4860F9-javax.annotation-api.jar
	http://hg.netbeans.org/binaries/E11C0F07A92F6D02A347DD9C55EE56692A6D9F7E-javax.xml.soap-api.jar
	http://hg.netbeans.org/binaries/EB77D3664EEA27D67B799ED28CB766B4D0971505-jaxb-api-osgi.jar
	http://hg.netbeans.org/binaries/45EBA8B0520A70787D5DD2EA154ACE152F817C0D-jaxb-api-osgi.jar
	http://hg.netbeans.org/binaries/C614ECF62381F88208D66D96146A8307781058DB-jaxrs-ri-2.5.1.zip
	http://hg.netbeans.org/binaries/D4C96D968F87B1BFEF138E91E06C8FD4A1904208-jaxws-api.jar
	http://hg.netbeans.org/binaries/B9DB1A789C301F1D31DD6CC524DA2EBD7F89190D-jsf-1.2.zip
	http://hg.netbeans.org/binaries/99277566601C4D5C2598B0206B5DC071932F3641-jsf-2.2.zip
	http://hg.netbeans.org/binaries/93A58E37BA1D014375B1578F3D904736CB2D408F-jsf-api-docs.zip
	http://hg.netbeans.org/binaries/F072F63AB1689E885AC40C221DF3E6BB3E64A84A-jstl-api.jar
	http://hg.netbeans.org/binaries/5B2E83EF42B4EEF0A7E41D43BB1D4B835F59AC7A-jstl-impl.jar
	http://hg.netbeans.org/binaries/FDECFB78184C7D19E7E20130A7D7E88C1DF0BDD1-metro-1.4-doc.zip
	http://hg.netbeans.org/binaries/F05AE8173BC750ECF1B52AD1F80050226458E490-metro-2.0.zip
	http://hg.netbeans.org/binaries/065BDCE80509320280B3B5210FCDDAE9B7D50338-primefaces-5.0.jar
	http://hg.netbeans.org/binaries/68C97A238A2143B616879E8C1EF5BF01EA25B11E-servlet3.1-jsp2.3-api.jar
	http://hg.netbeans.org/binaries/9319FDBED11E0D2EB03E4BB9E94BAA439A1DA469-struts-1.3.10-javadoc.zip
	http://hg.netbeans.org/binaries/9E226CFC08177A6666E5A2C535C25837A92C54C9-struts-1.3.10-lib.zip
	http://hg.netbeans.org/binaries/F6E990DF59BD1FD2058320002A853A5411A45CD4-syntaxref20.zip
	http://hg.netbeans.org/binaries/A5744971ACE1F44A0FC71CCB93DE530CB3022965-webservices-api-osgi.jar"
LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}"

CDEPEND="~dev-java/netbeans-ide-${PV}
	~dev-java/netbeans-harness-${PV}
	~dev-java/netbeans-ide-${PV}
	~dev-java/netbeans-java-${PV}
	~dev-java/netbeans-profiler-${PV}
	~dev-java/netbeans-platform-${PV}
	~dev-java/netbeans-webcommon-${PV}
	~dev-java/netbeans-websvccommon-${PV}
	dev-java/commons-codec:0
	dev-java/commons-fileupload:0
	dev-java/commons-logging:0
	dev-java/glassfish-deployment-api:1.2
	dev-java/jsr181:0"
DEPEND=">=virtual/jdk-1.7
	app-arch/unzip
	${CDEPEND}
	dev-java/javahelp:0
	>=dev-java/junit-4.4:4
	dev-java/tomcat-servlet-api:2.3"
RDEPEND="|| ( virtual/jdk:1.7 virtual/jdk:1.8 )
	${CDEPEND}
	>=dev-java/antlr-2.7.7-r7:0
	dev-java/bsf:2.3
	dev-java/cglib:3
	dev-java/commons-beanutils:1.7
	dev-java/commons-collections:0
	dev-java/commons-digester:0
	dev-java/commons-io:1
	dev-java/commons-validator:0
	dev-java/glassfish-persistence:0
	dev-java/guava:14
	dev-java/jakarta-oro:2.0
	dev-java/osgi-core-api:0
	dev-java/validation-api:1.0"
#	dev-java/commons-chain:1.1 in overlay

INSTALL_DIR="/usr/share/${PN}-${SLOT}"

EANT_BUILD_XML="nbbuild/build.xml"
EANT_BUILD_TARGET="rebuild-cluster"
EANT_EXTRA_ARGS="-Drebuild.cluster.name=nb.cluster.enterprise -Dext.binaries.downloaded=true -Dpermit.jdk8.builds=true"
EANT_FILTER_COMPILER="ecj-3.3 ecj-3.4 ecj-3.5 ecj-3.6 ecj-3.7"
JAVA_PKG_BSFIX="off"

src_unpack() {
	unpack $(basename ${SOURCE_URL})

	einfo "Deleting bundled jars..."
	find -name "*.jar" -type f -delete

	unpack netbeans-8.2-build.xml.patch.bz2

	pushd "${S}" >/dev/null || die
	ln -s "${DISTDIR}"/8BFEBCD4B39B87BBE788B4EECED068C8DBE75822-aws-java-sdk-1.2.1.jar libs.amazon/external/aws-java-sdk-1.2.1.jar || die
	ln -s "${DISTDIR}"/BA8A45A96AFE07D914DE153E0BB137DCDC7734F6-el-impl.jar libs.elimpl/external/el-impl.jar || die
	ln -s "${DISTDIR}"/33B0D0945555A06B74931DEACF9DB1A4AE2A3EC4-glassfish-jspparser-4.0.jar web.jspparser/external/glassfish-jspparser-4.0.jar || die
	ln -s "${DISTDIR}"/D813E05A06B587CD0FE36B00442EAB03C1431AA9-glassfish-logging-2.0.jar libs.glassfish_logging/external/glassfish-logging-2.0.jar || die
	ln -s "${DISTDIR}"/3D74BFB229C259E2398F2B383D5425CB81C643F0-httpclient-4.1.1.jar libs.amazon/external/httpclient-4.1.1.jar || die
	ln -s "${DISTDIR}"/33FC26C02F8043AB0EDE19EADC8C9885386B255C-httpcore-4.1.jar libs.amazon/external/httpcore-4.1.jar || die
	ln -s "${DISTDIR}"/D6F416983EA13C334D5C599A9045414ECAF5D66D-javaee-api-6.0.jar javaee.api/external/javaee-api-6.0.jar || die
	ln -s "${DISTDIR}"/51399F902CC27A808122EDCBEBFAA1AD989954BA-javaee-api-7.0.jar javaee7.api/external/javaee-api-7.0.jar || die
	ln -s "${DISTDIR}"/EBEC44255251E6D3B8DDBAF701F732DAF0238CBF-javaee-web-api-6.0.jar javaee.api/external/javaee-web-api-6.0.jar || die
	ln -s "${DISTDIR}"/B1FCE45BA94108EBF7E1CACE6427EC8761CABEC1-javaee-web-api-7.0.jar javaee7.api/external/javaee-web-api-7.0.jar || die
	ln -s "${DISTDIR}"/27E9711AA35C39EF455BFD900D544BACB99C0E89-javaee-doc-api.jar j2ee.platform/external/javaee-doc-api.jar || die
	ln -s "${DISTDIR}"/B290091E71DEED6CE7F9EB40523D49C26399A2B4-javax.annotation.jar javaee.api/external/javax.annotation.jar || die
	ln -s "${DISTDIR}"/1DEEA980904E39C3D7AA240B72CDBBEB8E4860F9-javax.annotation-api.jar javaee7.api/external/javax.annotation-api.jar || die
	ln -s "${DISTDIR}"/E11C0F07A92F6D02A347DD9C55EE56692A6D9F7E-javax.xml.soap-api.jar javaee7.api/external/javax.xml.soap-api.jar || die
	ln -s "${DISTDIR}"/EB77D3664EEA27D67B799ED28CB766B4D0971505-jaxb-api-osgi.jar javaee.api/external/jaxb-api-osgi.jar || die
	ln -s "${DISTDIR}"/45EBA8B0520A70787D5DD2EA154ACE152F817C0D-jaxb-api-osgi.jar javaee7.api/external/jaxb-api-osgi.jar || die
	ln -s "${DISTDIR}"/C614ECF62381F88208D66D96146A8307781058DB-jaxrs-ri-2.5.1.zip websvc.restlib/external/jaxrs-ri-2.5.1.zip || die
	ln -s "${DISTDIR}"/D4C96D968F87B1BFEF138E91E06C8FD4A1904208-jaxws-api.jar javaee7.api/external/jaxws-api.jar || die
	ln -s "${DISTDIR}"/B9DB1A789C301F1D31DD6CC524DA2EBD7F89190D-jsf-1.2.zip web.jsf12/external/jsf-1.2.zip || die
	ln -s "${DISTDIR}"/99277566601C4D5C2598B0206B5DC071932F3641-jsf-2.2.zip web.jsf20/external/jsf-2.2.zip || die
	ln -s "${DISTDIR}"/93A58E37BA1D014375B1578F3D904736CB2D408F-jsf-api-docs.zip web.jsf.editor/external/jsf-api-docs.zip || die
	ln -s "${DISTDIR}"/F072F63AB1689E885AC40C221DF3E6BB3E64A84A-jstl-api.jar libs.jstl/external/jstl-api.jar || die
	ln -s "${DISTDIR}"/5B2E83EF42B4EEF0A7E41D43BB1D4B835F59AC7A-jstl-impl.jar libs.jstl/external/jstl-impl.jar || die
	ln -s "${DISTDIR}"/FDECFB78184C7D19E7E20130A7D7E88C1DF0BDD1-metro-1.4-doc.zip websvc.metro.lib/external/metro-1.4-doc.zip || die
	ln -s "${DISTDIR}"/F05AE8173BC750ECF1B52AD1F80050226458E490-metro-2.0.zip websvc.metro.lib/external/metro-2.0.zip || die
	ln -s "${DISTDIR}"/065BDCE80509320280B3B5210FCDDAE9B7D50338-primefaces-5.0.jar web.primefaces/external/primefaces-5.0.jar || die
	ln -s "${DISTDIR}"/68C97A238A2143B616879E8C1EF5BF01EA25B11E-servlet3.1-jsp2.3-api.jar servletjspapi/external/servlet3.1-jsp2.3-api.jar || die
	ln -s "${DISTDIR}"/9319FDBED11E0D2EB03E4BB9E94BAA439A1DA469-struts-1.3.10-javadoc.zip web.struts/external/struts-1.3.10-javadoc.zip || die
	ln -s "${DISTDIR}"/9E226CFC08177A6666E5A2C535C25837A92C54C9-struts-1.3.10-lib.zip web.struts/external/struts-1.3.10-lib.zip || die
	ln -s "${DISTDIR}"/F6E990DF59BD1FD2058320002A853A5411A45CD4-syntaxref20.zip web.core.syntax/external/syntaxref20.zip || die
	ln -s "${DISTDIR}"/A5744971ACE1F44A0FC71CCB93DE530CB3022965-webservices-api-osgi.jar javaee.api/external/webservices-api-osgi.jar || die
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
	java-pkg_jar-from --into j2eeapis/external glassfish-deployment-api-1.2 glassfish-deployment-api.jar jsr88javax.jar
	java-pkg_jar-from --into libs.amazon/external commons-codec commons-codec.jar commons-codec-1.3.jar
	java-pkg_jar-from --into libs.amazon/external commons-logging commons-logging.jar commons-logging-1.1.1.jar
	java-pkg_jar-from --into libs.commons_fileupload/external commons-fileupload commons-fileupload.jar commons-fileupload-1.3.jar
	java-pkg_jar-from --into javaee7.api/external jsr181 jsr181.jar jsr181-api.jar
	java-pkg_jar-from --build-only --into libs.junit4/external junit-4 junit.jar junit-4.12.jar
	java-pkg_jar-from --build-only --into web.monitor/external tomcat-servlet-api-2.3 servlet.jar servlet-2.3.jar

	einfo "Linking in other clusters..."
	mkdir "${S}"/nbbuild/netbeans || die
	pushd "${S}"/nbbuild/netbeans >/dev/null || die

	ln -s /usr/share/netbeans-extide-${SLOT} extide || die
	cat /usr/share/netbeans-extide-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.extide.built

	ln -s /usr/share/netbeans-harness-${SLOT} harness || die
	cat /usr/share/netbeans-harness-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.harness.built

	ln -s /usr/share/netbeans-ide-${SLOT} ide || die
	cat /usr/share/netbeans-ide-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.ide.built

	ln -s /usr/share/netbeans-java-${SLOT} java || die
	cat /usr/share/netbeans-java-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.java.built

	ln -s /usr/share/netbeans-profiler-${SLOT} profiler || die
	cat /usr/share/netbeans-profiler-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.profiler.built

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
}

src_install() {
	pushd nbbuild/netbeans/enterprise >/dev/null || die

	insinto ${INSTALL_DIR}

	grep -E "/enterprise$" ../moduleCluster.properties > "${D}"/${INSTALL_DIR}/moduleCluster.properties || die

	doins -r *

	popd >/dev/null || die

	local instdir="${D}"/${INSTALL_DIR}/modules/ext
	pushd "${instdir}" >/dev/null || die
	rm commons-fileupload-1.3.jar && java-pkg_jar-from --into "${instdir}" commons-fileupload commons-fileupload.jar commons-fileupload-1.3.jar
	rm jsr88javax.jar && java-pkg_jar-from --into "${instdir}" glassfish-deployment-api-1.2 glassfish-deployment-api.jar jsr88javax.jar
	popd >/dev/null || die

	local instdir="${D}"/${INSTALL_DIR}/modules/ext/aws-sdk
	pushd "${instdir}" >/dev/null || die
	rm commons-codec-1.3.jar && java-pkg_jar-from --into "${instdir}" commons-codec commons-codec.jar commons-codec-1.3.jar
	rm commons-logging-1.1.1.jar && java-pkg_jar-from --into "${instdir}" commons-logging commons-logging.jar commons-logging-1.1.1.jar
	popd >/dev/null || die

	local instdir="${D}"/${INSTALL_DIR}/modules/ext/javaee7-endorsed
	pushd "${instdir}" >/dev/null || die
	rm jsr181-api.jar && java-pkg_jar-from --into "${instdir}" jsr181 jsr181.jar jsr181-api.jar
	popd >/dev/null || die

	local instdir="${D}"/${INSTALL_DIR}/modules/ext/jersey2/ext
	pushd "${instdir}" >/dev/null || die
	rm cglib-2.2.0-b21.jar && java-pkg_jar-from --into "${instdir}" cglib-3 cglib.jar cglib-2.2.0-b21.jar
	rm guava-14.0.1.jar && java-pkg_jar-from --into "${instdir}" guava-14 guava.jar guava-14.0.1.jar
	rm org.osgi.core-4.2.0.jar && java-pkg_jar-from --into "${instdir}" osgi-core-api osgi-core-api.jar org.osgi.core-4.2.0.jar
	rm persistence-api-1.0.jar && java-pkg_jar-from --into "${instdir}" glassfish-persistence glassfish-persistence.jar persistence-api-1.0.jar
	rm validation-api-1.1.0.Final.jar && java-pkg_jar-from --into "${instdir}" validation-api-1.0 validation-api.jar validation-api-1.1.0.Final.jar
	popd >/dev/null || die

	local instdir="${D}"/${INSTALL_DIR}/modules/ext/jsf-1_2
	pushd "${instdir}" >/dev/null || die
	rm commons-beanutils.jar && java-pkg_jar-from --into "${instdir}" commons-beanutils-1.7 commons-beanutils.jar
	rm commons-collections.jar && java-pkg_jar-from --into "${instdir}" commons-collections commons-collections.jar
	rm commons-digester.jar && java-pkg_jar-from --into "${instdir}" commons-digester commons-digester.jar
	rm commons-logging.jar && java-pkg_jar-from --into "${instdir}" commons-logging commons-logging.jar
	popd >/dev/null || die

	local instdir="${D}"/${INSTALL_DIR}/modules/ext/struts
	pushd "${instdir}" >/dev/null || die
	rm antlr-2.7.2.jar && java-pkg_jar-from --into "${instdir}" antlr antlr.jar antlr-2.7.2.jar
	rm bsf-2.3.0.jar && java-pkg_jar-from --into "${instdir}" bsf-2.3 bsf.jar bsf-2.3.0.jar
	rm commons-beanutils-1.8.0.jar && java-pkg_jar-from --into "${instdir}" commons-beanutils-1.7 commons-beanutils.jar commons-beanutils-1.8.0.jar
	rm commons-digester-1.8.jar && java-pkg_jar-from --into "${instdir}" commons-digester commons-digester.jar commons-digester-1.8.jar
	rm commons-fileupload-1.1.1.jar && java-pkg_jar-from --into "${instdir}" commons-fileupload commons-fileupload.jar commons-fileupload-1.1.1.jar
	rm commons-io-1.1.jar && java-pkg_jar-from --into "${instdir}" commons-io-1 commons-io.jar commons-io-1.1.jar
	rm commons-logging-1.0.4.jar && java-pkg_jar-from --into "${instdir}" commons-logging commons-logging.jar commons-logging-1.0.4.jar
	rm commons-validator-1.3.1.jar && java-pkg_jar-from --into "${instdir}" commons-validator commons-validator.jar commons-validator-1.3.1.jar
	rm oro-2.0.8.jar && java-pkg_jar-from --into "${instdir}" jakarta-oro-2.0 jakarta-oro.jar oro-2.0.8.jar
	popd >/dev/null || die

	dosym ${INSTALL_DIR} /usr/share/netbeans-nb-${SLOT}/enterprise
}
