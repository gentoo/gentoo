# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Netbeans IDE Cluster"
HOMEPAGE="http://netbeans.org/projects/ide"
SLOT="8.0"
SOURCE_URL="http://download.netbeans.org/netbeans/8.0.2/final/zip/netbeans-8.0.2-201411181905-src.zip"
SRC_URI="${SOURCE_URL}
	https://dev.gentoo.org/~fordfrog/distfiles/netbeans-8.0.2-build.xml.patch.bz2
	http://hg.netbeans.org/binaries/4E74C6BE42FE89871A878C7C4D6158F21A6D8010-antlr-runtime-3.4.jar
	http://hg.netbeans.org/binaries/98308890597ACB64047F7E896638E0D98753AE82-asm-all-4.0.jar
	http://hg.netbeans.org/binaries/886FAF4B85054DD6E50D9B3438542F432B5F9251-bytelist-0.1.jar
	http://hg.netbeans.org/binaries/A8762D07E76CFDE2395257A5DA47BA7C1DBD3DCE-commons-io-1.4.jar
	http://hg.netbeans.org/binaries/CD0D5510908225F76C5FE5A3F1DF4FA44866F81E-commons-net-3.3.jar
	http://hg.netbeans.org/binaries/901D8F815922C435D985DA3814D20E34CC7622CB-css21-spec.zip
	http://hg.netbeans.org/binaries/53AFD6CAA1B476204557B0626E7D673FBD5D245C-css3-spec.zip
	http://hg.netbeans.org/binaries/C9A6304FAA121C97CB2458B93D30B1FD6F0F7691-derbysampledb.zip
	http://hg.netbeans.org/binaries/C40DFDACDF892D1BA14B540B32C11B6F34659931-exechlp-1.0.zip
	http://hg.netbeans.org/binaries/5EEAAC41164FEBCB79C73BEBD678A7B6C10C3E80-freemarker-2.3.19.jar
	http://hg.netbeans.org/binaries/75C30C488AD2A18A82C7FE3829F4A33FC7841643-glassfish-tooling-sdk-0.3-b054-246345.jar
	http://hg.netbeans.org/binaries/23123BB29025254556B6E573023FCDF0F6715A66-html-4.01.zip
	http://hg.netbeans.org/binaries/F4A1696661E6233F8C27EE323CAEF9CB052666F1-html5-datatypes.jar
	http://hg.netbeans.org/binaries/4388C34B9F085A42FBEA06C5B00FDF0A251171EC-html5doc.zip
	http://hg.netbeans.org/binaries/D528B44AE7593D2275927396BF930B28078C5220-htmlparser-1.2.1.jar
	http://hg.netbeans.org/binaries/8E737D82ECAC9BA6100A9BBA71E92A381B75EFDC-ini4j-0.5.1.jar
	http://hg.netbeans.org/binaries/A2862B7795EF0E0F0716BEC84528FA3B629E479C-io-xml-util.jar
	http://hg.netbeans.org/binaries/0DCC973606CBD9737541AA5F3E76DED6E3F4D0D0-iri.jar
	http://hg.netbeans.org/binaries/F90E3DA5259DB07F36E6987EFDED647A5231DE76-ispell-enwl-3.1.20.zip
	http://hg.netbeans.org/binaries/71F434378F822B09A57174AF6C75D37408687C57-jaxb-api.jar
	http://hg.netbeans.org/binaries/27FAE927B5B9AE53A5B0ED825575DD8217CE7042-jaxb-api-doc.zip
	http://hg.netbeans.org/binaries/387BE740EAEF52B3F6E6EE2F140757E7632584CE-jaxb-impl.jar
	http://hg.netbeans.org/binaries/C3787DAB0DDFBD9E98086ED2F219859B0CB77EF7-jaxb-xjc.jar
	http://hg.netbeans.org/binaries/F4DB465F207907A2406B0BF5C8FFEE22A5C3E4E3-jaxb1-impl.jar
	http://hg.netbeans.org/binaries/5E40984A55F6FFF704F05D511A119CA5B456DDB1-jfxrt.jar
	http://hg.netbeans.org/binaries/483A61B688B13C62BB201A683D98A6688B5373B6-jing.jar
	http://hg.netbeans.org/binaries/DA6CE3C2EB334DB61EFA99CD66134619867368FA-js-corestubs.zip
	http://hg.netbeans.org/binaries/997BF4A93B8A99E37AB51C9016D1D18CF5FF4B60-js-domstubs.zip
	http://hg.netbeans.org/binaries/A723CD3E76C92CFE563B602035532C1C9D3D7192-js-reststubs.zip
	http://hg.netbeans.org/binaries/036FA0032B44AD06A1F13504D97B3685B1C88961-jsch.agentproxy.core-0.0.7.jar
	http://hg.netbeans.org/binaries/9F31964104D71855DF6B73F0C761CDEB3FA3C49C-jsch.agentproxy.sshagent-0.0.7.jar
	http://hg.netbeans.org/binaries/3FA59A536F3DC2197826DC7F224C0823C1534203-jsch.agentproxy.pageant-0.0.7.jar
	http://hg.netbeans.org/binaries/F759114E5A9F9AE907EADB59DBF65189AA399B45-jsch.agentproxy.usocket-jna-0.0.7.jar
	http://hg.netbeans.org/binaries/2E07375E5CA3A452472F0E87FB33F243F7A5C08C-libpam4j-1.1.jar
	http://hg.netbeans.org/binaries/76E901A1F432323E7E90FC86FDB2534A28952293-nashorn-02f810c26ff9-patched.jar
	http://hg.netbeans.org/binaries/010FC8BD229B7F68C8C4D5BDE399475373096601-non-schema.jar
	http://hg.netbeans.org/binaries/7052E115041D04410A4519A61307502FB7C138E6-org.eclipse.core.contenttype_3.4.100.v20110423-0524.jar
	http://hg.netbeans.org/binaries/B19A4D998C76FE7A30830C96B9E3A47682F320FC-org.eclipse.core.jobs-3.5.101.jar
	http://hg.netbeans.org/binaries/E64EF6A3FC5DB01AD95632B843706CCE56614C90-org.eclipse.core.net_1.2.100.I20110511-0800.jar
	http://hg.netbeans.org/binaries/6658C235056134F7E86295E751129508802D71F2-org.eclipse.core.runtime-3.7.0.jar
	http://hg.netbeans.org/binaries/0CA9B9DF8A8E4C6805C60A5761C470FCE8AE828F-org.eclipse.core.runtime.compatibility.auth_3.2.200.v20110110.jar
	http://hg.netbeans.org/binaries/9C74D245214DB08E7EB9BC07A951B41CFE3E3648-org.eclipse.equinox.app-1.3.100.jar
	http://hg.netbeans.org/binaries/78E5D0B8516B042495660DA36CE5114650F8F156-org.eclipse.equinox.common_3.6.0.v20110523.jar
	http://hg.netbeans.org/binaries/FD94003A1BCE42008753522BFED68E5A84B92644-org.eclipse.equinox.preferences-3.4.2.jar
	http://hg.netbeans.org/binaries/54AE046B40C9095C2637F8D21664C5CD76E34485-org.eclipse.equinox.registry_3.5.200.v20120522-1841.jar
	http://hg.netbeans.org/binaries/0FFB9B1D7CD992CE6C8AAEEC2F6F98DFBB1D2F91-org.eclipse.equinox.security-1.1.1.jar
	http://hg.netbeans.org/binaries/7FE73A21F4A078ABAAFACE4D2B03B5EB3D306F63-org.eclipse.jgit-3.4.1.201406201815-r.jar
	http://hg.netbeans.org/binaries/49F1EFEBC8CECA5D514209BE18A048EB5707C0A7-org.eclipse.jgit.java7-3.4.1.201406201815-r.jar
	http://hg.netbeans.org/binaries/A94F8F805202B28236FFBC03C1CA149129DAEA1C-org.eclipse.mylyn.bugzilla.core_3.10.0.20131024-1218.jar
	http://hg.netbeans.org/binaries/19D64C17A692D2023E22B16AD515118DF6427790-org.eclipse.mylyn.commons.core_3.10.0.20130926-1710.jar
	http://hg.netbeans.org/binaries/A1BF01D1DD09274446738C3F83360314B8881CD5-org.eclipse.mylyn.commons.net_3.10.0.20131018-1210.jar
	http://hg.netbeans.org/binaries/136A7EB3BB9B2559C5F9184B438F108C959B3C03-org.eclipse.mylyn.commons.repositories.core_1.2.0.20130704-2116.jar
	http://hg.netbeans.org/binaries/531746EBE57071AB7F8CCC7ACB0E806F25893916-org.eclipse.mylyn.commons.xmlrpc_3.10.0.20130704-2116.jar
	http://hg.netbeans.org/binaries/D3ED088A49DE9E5163457E9279181DD4185BFBE6-org.eclipse.mylyn.tasks.core_3.10.0.20131010-2023.jar
	http://hg.netbeans.org/binaries/8D4278A9F47D17A104182E59CF06D682B3DE0B3E-org.eclipse.mylyn.wikitext.confluence.core_1.9.0.20131007-2055.jar
	http://hg.netbeans.org/binaries/1FC011B8A350B70950B3F1D722D7F2890C6E76D8-org.eclipse.mylyn.wikitext.core_1.9.0.20131007-2055.jar
	http://hg.netbeans.org/binaries/6E914CA3075C8FDF7652F04A02868CF32F2EDCE3-org.eclipse.mylyn.wikitext.textile.core_1.9.0.20131007-2055.jar
	http://hg.netbeans.org/binaries/8A2F6232978E0330A5D36F19BA0686F96FB980B5-org.tmatesoft.svnkit_1.8.4.r10218_v20140302_1242.jar
	http://hg.netbeans.org/binaries/820FD32B3FB7F885996B15474F220BDCCACD6D27-processtreekiller-1.0.2.jar
	http://hg.netbeans.org/binaries/B0D0FCBAC68826D2AFA3C7C89FC4D57B95A000C3-resolver-1.2.jar
	http://hg.netbeans.org/binaries/D08E473A4D0510FB329D64E4CC4F2963D000699C-svnClientAdapter-javahl-1.10.3.jar
	http://hg.netbeans.org/binaries/2CD487DCDE4C4FC38D1C9EBCD45418A1B5EF188D-svnClientAdapter-main-1.10.3.jar
	http://hg.netbeans.org/binaries/5D37A7FE167A1D44731192748C79B2D7905D474F-svnClientAdapter-svnkit-1.10.3.jar
	http://hg.netbeans.org/binaries/24CEAE4A9A2AAAA0BD78FF001914BA06B59CEDF2-svnjavahl-1.8.4.jar
	http://hg.netbeans.org/binaries/4F94E5B4F14B4571A1D8E37885A3037C91F7C02C-svnkit_1.7.8.r9538_v20130107_2001.jar
	http://hg.netbeans.org/binaries/C0D8A3265D194CC886BAFD585117B6465FD97DCE-swingx-all-1.6.4.jar
	http://hg.netbeans.org/binaries/EDE7FBABD4C96D34E48FDA0E8FECED24C98CEDCA-sqljet-1.1.10.jar
	http://hg.netbeans.org/binaries/CD5B5996B46CB8D96C8F0F89A7A734B3C01F3DF7-tomcat-webserver-3.2.jar
	http://hg.netbeans.org/binaries/CE9A1C96875443F2FDD5127B750DA39CF4CE818B-com.trilead.ssh2_1.0.0.build217_r155_v20130603_1628.jar
	http://hg.netbeans.org/binaries/89BC047153217F5254506F4C622A771A78883CBC-ValidationAPI.jar
	http://hg.netbeans.org/binaries/6FC6098C230D7CBA5730106D379CBBB42F6EC48A-validator.jar
	http://hg.netbeans.org/binaries/C9757EFB2CFBA523A7375A78FA9ECFAF0D0AC505-winp-1.14-patched.jar
	http://hg.netbeans.org/binaries/64F5BEEADD2A239C4BC354B8DFDB97CF7FDD9983-xmlrpc-client-3.0.jar
	http://hg.netbeans.org/binaries/8FA16AD28B5E79A7CD52B8B72985B0AE8CCD6ADF-xmlrpc-common-3.0.jar
	http://hg.netbeans.org/binaries/D6917BF718583002CBE44E773EE21E2DF08ADC71-xmlrpc-server-3.0.jar"
LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
KEYWORDS="amd64 x86"
IUSE=""
S="${WORKDIR}"

CDEPEND="~dev-java/netbeans-harness-${PV}
	~dev-java/netbeans-platform-${PV}
	dev-java/commons-httpclient:3
	dev-java/commons-lang:2.1
	dev-java/commons-logging:0
	dev-java/icu4j:4.4
	dev-java/iso-relax:0
	dev-java/jdbc-mysql:0
	dev-java/jdbc-postgresql:0
	>=dev-java/json-simple-1.1:0
	dev-java/jsr173:0
	dev-java/jvyamlb:0
	dev-java/log4j:0
	dev-java/lucene:3.5
	dev-java/rhino:1.6
	dev-java/saxon:9
	dev-java/smack:2.2
	dev-java/sun-jaf:0
	dev-java/tomcat-servlet-api:2.2
	dev-java/ws-commons-util:0
	dev-java/xerces:2"
#	dev-vcs/subversion>=1.8.4:0[java] missing from the tree
#	app-text/jing:0 our version is probably too old
#	dev-java/commons-io:1 fails with "Missing manifest tag OpenIDE-Module"
#	dev-java/freemarker:2.3
#	dev-java/ini4j:0 our version is too old
#	dev-java/jaxb:2 upstream version contains more stuff so websvccommon does not compile with ours
#	dev-java/trilead-ssh2:0 in overlay
DEPEND="virtual/jdk:1.7
	app-arch/unzip
	dev-java/commons-codec:0
	>=dev-java/jsch-0.1.46:0
	dev-java/jzlib:0
	${CDEPEND}
	dev-java/javacc:0
	dev-java/javahelp:0"
RDEPEND=">=virtual/jdk-1.7
	${CDEPEND}"

INSTALL_DIR="/usr/share/${PN}-${SLOT}"

EANT_BUILD_XML="nbbuild/build.xml"
EANT_BUILD_TARGET="rebuild-cluster"
EANT_EXTRA_ARGS="-Drebuild.cluster.name=nb.cluster.ide -Dext.binaries.downloaded=true -Djava.awt.headless=true"
EANT_FILTER_COMPILER="ecj-3.3 ecj-3.4 ecj-3.5 ecj-3.6 ecj-3.7"
JAVA_PKG_BSFIX="off"

JAVA_PKG_WANT_SOURCE="1.7"
JAVA_PKG_WANT_TARGET="1.7"

src_unpack() {
	unpack $(basename ${SOURCE_URL})

	einfo "Deleting bundled jars..."
	find -name "*.jar" -type f -delete

	unpack netbeans-8.0.2-build.xml.patch.bz2

	pushd "${S}" >/dev/null || die
	ln -s "${DISTDIR}"/4E74C6BE42FE89871A878C7C4D6158F21A6D8010-antlr-runtime-3.4.jar libs.antlr3.runtime/external/antlr-runtime-3.4.jar || die
	ln -s "${DISTDIR}"/98308890597ACB64047F7E896638E0D98753AE82-asm-all-4.0.jar libs.nashorn/external/asm-all-4.0.jar || die
	ln -s "${DISTDIR}"/886FAF4B85054DD6E50D9B3438542F432B5F9251-bytelist-0.1.jar libs.bytelist/external/bytelist-0.1.jar || die
	ln -s "${DISTDIR}"/A8762D07E76CFDE2395257A5DA47BA7C1DBD3DCE-commons-io-1.4.jar o.apache.commons.io/external/commons-io-1.4.jar || die
	ln -s "${DISTDIR}"/CD0D5510908225F76C5FE5A3F1DF4FA44866F81E-commons-net-3.3.jar libs.commons_net/external/commons-net-3.3.jar || die
	ln -s "${DISTDIR}"/901D8F815922C435D985DA3814D20E34CC7622CB-css21-spec.zip css.editor/external/css21-spec.zip || die
	ln -s "${DISTDIR}"/53AFD6CAA1B476204557B0626E7D673FBD5D245C-css3-spec.zip css.editor/external/css3-spec.zip || die
	ln -s "${DISTDIR}"/C9A6304FAA121C97CB2458B93D30B1FD6F0F7691-derbysampledb.zip derby/external/derbysampledb.zip || die
	ln -s "${DISTDIR}"/C40DFDACDF892D1BA14B540B32C11B6F34659931-exechlp-1.0.zip dlight.nativeexecution/external/exechlp-1.0.zip || die
	ln -s "${DISTDIR}"/5EEAAC41164FEBCB79C73BEBD678A7B6C10C3E80-freemarker-2.3.19.jar libs.freemarker/external/freemarker-2.3.19.jar || die
	ln -s "${DISTDIR}"/75C30C488AD2A18A82C7FE3829F4A33FC7841643-glassfish-tooling-sdk-0.3-b054-246345.jar libs.glassfish.sdk/external/glassfish-tooling-sdk-0.3-b054-246345.jar || die
	ln -s "${DISTDIR}"/23123BB29025254556B6E573023FCDF0F6715A66-html-4.01.zip html.editor/external/html-4.01.zip || die
	ln -s "${DISTDIR}"/F4A1696661E6233F8C27EE323CAEF9CB052666F1-html5-datatypes.jar html.validation/external/html5-datatypes.jar || die
	ln -s "${DISTDIR}"/4388C34B9F085A42FBEA06C5B00FDF0A251171EC-html5doc.zip html.parser/external/html5doc.zip || die
	ln -s "${DISTDIR}"/D528B44AE7593D2275927396BF930B28078C5220-htmlparser-1.2.1.jar html.parser/external/htmlparser-1.2.1.jar || die
	ln -s "${DISTDIR}"/8E737D82ECAC9BA6100A9BBA71E92A381B75EFDC-ini4j-0.5.1.jar libs.ini4j/external/ini4j-0.5.1.jar || die
	ln -s "${DISTDIR}"/A2862B7795EF0E0F0716BEC84528FA3B629E479C-io-xml-util.jar html.validation/external/io-xml-util.jar || die
	ln -s "${DISTDIR}"/0DCC973606CBD9737541AA5F3E76DED6E3F4D0D0-iri.jar html.validation/external/iri.jar || die
	ln -s "${DISTDIR}"/F90E3DA5259DB07F36E6987EFDED647A5231DE76-ispell-enwl-3.1.20.zip spellchecker.dictionary_en/external/ispell-enwl-3.1.20.zip || die
	ln -s "${DISTDIR}"/71F434378F822B09A57174AF6C75D37408687C57-jaxb-api.jar xml.jaxb.api/external/jaxb-api.jar || die
	ln -s "${DISTDIR}"/27FAE927B5B9AE53A5B0ED825575DD8217CE7042-jaxb-api-doc.zip libs.jaxb/external/jaxb-api-doc.zip || die
	ln -s "${DISTDIR}"/387BE740EAEF52B3F6E6EE2F140757E7632584CE-jaxb-impl.jar libs.jaxb/external/jaxb-impl.jar || die
	ln -s "${DISTDIR}"/C3787DAB0DDFBD9E98086ED2F219859B0CB77EF7-jaxb-xjc.jar libs.jaxb/external/jaxb-xjc.jar || die
	ln -s "${DISTDIR}"/F4DB465F207907A2406B0BF5C8FFEE22A5C3E4E3-jaxb1-impl.jar libs.jaxb/external/jaxb1-impl.jar || die
	ln -s "${DISTDIR}"/5E40984A55F6FFF704F05D511A119CA5B456DDB1-jfxrt.jar libs.javafx/external/jfxrt.jar || die
	ln -s "${DISTDIR}"/483A61B688B13C62BB201A683D98A6688B5373B6-jing.jar html.validation/external/jing.jar || die
	ln -s "${DISTDIR}"/DA6CE3C2EB334DB61EFA99CD66134619867368FA-js-corestubs.zip javascript2.editor/external/js-corestubs.zip || die
	ln -s "${DISTDIR}"/997BF4A93B8A99E37AB51C9016D1D18CF5FF4B60-js-domstubs.zip javascript2.editor/external/js-domstubs.zip || die
	ln -s "${DISTDIR}"/A723CD3E76C92CFE563B602035532C1C9D3D7192-js-reststubs.zip javascript2.editor/external/js-reststubs.zip || die
	ln -s "${DISTDIR}"/036FA0032B44AD06A1F13504D97B3685B1C88961-jsch.agentproxy.core-0.0.7.jar libs.jsch.agentproxy/external/jsch.agentproxy.core-0.0.7.jar || die
	ln -s "${DISTDIR}"/9F31964104D71855DF6B73F0C761CDEB3FA3C49C-jsch.agentproxy.sshagent-0.0.7.jar libs.jsch.agentproxy/external/jsch.agentproxy.sshagent-0.0.7.jar || die
	ln -s "${DISTDIR}"/3FA59A536F3DC2197826DC7F224C0823C1534203-jsch.agentproxy.pageant-0.0.7.jar libs.jsch.agentproxy/external/jsch.agentproxy.pageant-0.0.7.jar || die
	ln -s "${DISTDIR}"/F759114E5A9F9AE907EADB59DBF65189AA399B45-jsch.agentproxy.usocket-jna-0.0.7.jar libs.jsch.agentproxy/external/jsch.agentproxy.usocket-jna-0.0.7.jar || die
	ln -s "${DISTDIR}"/2E07375E5CA3A452472F0E87FB33F243F7A5C08C-libpam4j-1.1.jar extexecution.impl/external/libpam4j-1.1.jar || die
	ln -s "${DISTDIR}"/76E901A1F432323E7E90FC86FDB2534A28952293-nashorn-02f810c26ff9-patched.jar libs.nashorn/external/nashorn-02f810c26ff9-patched.jar || die
	ln -s "${DISTDIR}"/010FC8BD229B7F68C8C4D5BDE399475373096601-non-schema.jar html.validation/external/non-schema.jar || die
	ln -s "${DISTDIR}"/7052E115041D04410A4519A61307502FB7C138E6-org.eclipse.core.contenttype_3.4.100.v20110423-0524.jar o.eclipse.core.contenttype/external/org.eclipse.core.contenttype_3.4.100.v20110423-0524.jar || die
	ln -s "${DISTDIR}"/B19A4D998C76FE7A30830C96B9E3A47682F320FC-org.eclipse.core.jobs-3.5.101.jar o.eclipse.core.jobs/external/org.eclipse.core.jobs-3.5.101.jar || die
	ln -s "${DISTDIR}"/E64EF6A3FC5DB01AD95632B843706CCE56614C90-org.eclipse.core.net_1.2.100.I20110511-0800.jar o.eclipse.core.net/external/org.eclipse.core.net_1.2.100.I20110511-0800.jar || die
	ln -s "${DISTDIR}"/6658C235056134F7E86295E751129508802D71F2-org.eclipse.core.runtime-3.7.0.jar o.eclipse.core.runtime/external/org.eclipse.core.runtime-3.7.0.jar || die
	ln -s "${DISTDIR}"/0CA9B9DF8A8E4C6805C60A5761C470FCE8AE828F-org.eclipse.core.runtime.compatibility.auth_3.2.200.v20110110.jar o.eclipse.core.runtime.compatibility.auth/external/org.eclipse.core.runtime.compatibility.auth_3.2.200.v20110110.jar || die
	ln -s "${DISTDIR}"/9C74D245214DB08E7EB9BC07A951B41CFE3E3648-org.eclipse.equinox.app-1.3.100.jar o.eclipse.equinox.app/external/org.eclipse.equinox.app-1.3.100.jar || die
	ln -s "${DISTDIR}"/78E5D0B8516B042495660DA36CE5114650F8F156-org.eclipse.equinox.common_3.6.0.v20110523.jar o.eclipse.equinox.common/external/org.eclipse.equinox.common_3.6.0.v20110523.jar || die
	ln -s "${DISTDIR}"/FD94003A1BCE42008753522BFED68E5A84B92644-org.eclipse.equinox.preferences-3.4.2.jar o.eclipse.equinox.preferences/external/org.eclipse.equinox.preferences-3.4.2.jar || die
	ln -s "${DISTDIR}"/54AE046B40C9095C2637F8D21664C5CD76E34485-org.eclipse.equinox.registry_3.5.200.v20120522-1841.jar o.eclipse.equinox.registry/external/org.eclipse.equinox.registry_3.5.200.v20120522-1841.jar || die
	ln -s "${DISTDIR}"/0FFB9B1D7CD992CE6C8AAEEC2F6F98DFBB1D2F91-org.eclipse.equinox.security-1.1.1.jar o.eclipse.equinox.security/external/org.eclipse.equinox.security-1.1.1.jar || die
	ln -s "${DISTDIR}"/7FE73A21F4A078ABAAFACE4D2B03B5EB3D306F63-org.eclipse.jgit-3.4.1.201406201815-r.jar o.eclipse.jgit/external/org.eclipse.jgit-3.4.1.201406201815-r.jar || die
	ln -s "${DISTDIR}"/49F1EFEBC8CECA5D514209BE18A048EB5707C0A7-org.eclipse.jgit.java7-3.4.1.201406201815-r.jar o.eclipse.jgit.java7/external/org.eclipse.jgit.java7-3.4.1.201406201815-r.jar || die
	ln -s "${DISTDIR}"/A94F8F805202B28236FFBC03C1CA149129DAEA1C-org.eclipse.mylyn.bugzilla.core_3.10.0.20131024-1218.jar o.eclipse.mylyn.bugzilla.core/external/org.eclipse.mylyn.bugzilla.core_3.10.0.20131024-1218.jar || die
	ln -s "${DISTDIR}"/19D64C17A692D2023E22B16AD515118DF6427790-org.eclipse.mylyn.commons.core_3.10.0.20130926-1710.jar o.eclipse.mylyn.commons.core/external/org.eclipse.mylyn.commons.core_3.10.0.20130926-1710.jar || die
	ln -s "${DISTDIR}"/A1BF01D1DD09274446738C3F83360314B8881CD5-org.eclipse.mylyn.commons.net_3.10.0.20131018-1210.jar o.eclipse.mylyn.commons.net/external/org.eclipse.mylyn.commons.net_3.10.0.20131018-1210.jar || die
	ln -s "${DISTDIR}"/136A7EB3BB9B2559C5F9184B438F108C959B3C03-org.eclipse.mylyn.commons.repositories.core_1.2.0.20130704-2116.jar o.eclipse.mylyn.commons.repositories.core/external/org.eclipse.mylyn.commons.repositories.core_1.2.0.20130704-2116.jar || die
	ln -s "${DISTDIR}"/531746EBE57071AB7F8CCC7ACB0E806F25893916-org.eclipse.mylyn.commons.xmlrpc_3.10.0.20130704-2116.jar o.eclipse.mylyn.commons.xmlrpc/external/org.eclipse.mylyn.commons.xmlrpc_3.10.0.20130704-2116.jar || die
	ln -s "${DISTDIR}"/D3ED088A49DE9E5163457E9279181DD4185BFBE6-org.eclipse.mylyn.tasks.core_3.10.0.20131010-2023.jar o.eclipse.mylyn.tasks.core/external/org.eclipse.mylyn.tasks.core_3.10.0.20131010-2023.jar || die
	ln -s "${DISTDIR}"/8D4278A9F47D17A104182E59CF06D682B3DE0B3E-org.eclipse.mylyn.wikitext.confluence.core_1.9.0.20131007-2055.jar o.eclipse.mylyn.wikitext.confluence.core/external/org.eclipse.mylyn.wikitext.confluence.core_1.9.0.20131007-2055.jar || die
	ln -s "${DISTDIR}"/1FC011B8A350B70950B3F1D722D7F2890C6E76D8-org.eclipse.mylyn.wikitext.core_1.9.0.20131007-2055.jar o.eclipse.mylyn.wikitext.core/external/org.eclipse.mylyn.wikitext.core_1.9.0.20131007-2055.jar || die
	ln -s "${DISTDIR}"/6E914CA3075C8FDF7652F04A02868CF32F2EDCE3-org.eclipse.mylyn.wikitext.textile.core_1.9.0.20131007-2055.jar o.eclipse.mylyn.wikitext.textile.core/external/org.eclipse.mylyn.wikitext.textile.core_1.9.0.20131007-2055.jar  || die
	ln -s "${DISTDIR}"/8A2F6232978E0330A5D36F19BA0686F96FB980B5-org.tmatesoft.svnkit_1.8.4.r10218_v20140302_1242.jar libs.svnClientAdapter.svnkit/external/org.tmatesoft.svnkit_1.8.4.r10218_v20140302_1242.jar || die
	ln -s "${DISTDIR}"/4F94E5B4F14B4571A1D8E37885A3037C91F7C02C-svnkit_1.7.8.r9538_v20130107_2001.jar libs.svnClientAdapter.svnkit/external/svnkit_1.7.8.r9538_v20130107_2001.jar || die
	ln -s "${DISTDIR}"/820FD32B3FB7F885996B15474F220BDCCACD6D27-processtreekiller-1.0.2.jar extexecution.impl/external/processtreekiller-1.0.2.jar || die
	ln -s "${DISTDIR}"/B0D0FCBAC68826D2AFA3C7C89FC4D57B95A000C3-resolver-1.2.jar o.apache.xml.resolver/external/resolver-1.2.jar || die
	ln -s "${DISTDIR}"/EDE7FBABD4C96D34E48FDA0E8FECED24C98CEDCA-sqljet-1.1.10.jar libs.svnClientAdapter.svnkit/external/sqljet-1.1.10.jar || die
	ln -s "${DISTDIR}"/D08E473A4D0510FB329D64E4CC4F2963D000699C-svnClientAdapter-javahl-1.10.3.jar libs.svnClientAdapter.javahl/external/svnClientAdapter-javahl-1.10.3.jar || die
	ln -s "${DISTDIR}"/2CD487DCDE4C4FC38D1C9EBCD45418A1B5EF188D-svnClientAdapter-main-1.10.3.jar libs.svnClientAdapter/external/svnClientAdapter-main-1.10.3.jar || die
	ln -s "${DISTDIR}"/5D37A7FE167A1D44731192748C79B2D7905D474F-svnClientAdapter-svnkit-1.10.3.jar libs.svnClientAdapter.svnkit/external/svnClientAdapter-svnkit-1.10.3.jar || die
	ln -s "${DISTDIR}"/24CEAE4A9A2AAAA0BD78FF001914BA06B59CEDF2-svnjavahl-1.8.4.jar libs.svnClientAdapter.javahl/external/svnjavahl-1.8.4.jar || die
	ln -s "${DISTDIR}"/3B91269E9055504778F57744D24F505856698602-svnkit-1.7.0-beta4-20120316.233307-1.jar libs.svnClientAdapter.svnkit/external/svnkit-1.7.0-beta4-20120316.233307-1.jar || die
	ln -s "${DISTDIR}"/015525209A02BD74254930FF844C7C13498B7FB9-svnkit-javahl16-1.7.0-beta4-20120316.233536-1.jar libs.svnClientAdapter.svnkit/external/svnkit-javahl16-1.7.0-beta4-20120316.233536-1.jar || die
	ln -s "${DISTDIR}"/C0D8A3265D194CC886BAFD585117B6465FD97DCE-swingx-all-1.6.4.jar libs.swingx/external/swingx-all-1.6.4.jar || die
	ln -s "${DISTDIR}"/CD5B5996B46CB8D96C8F0F89A7A734B3C01F3DF7-tomcat-webserver-3.2.jar httpserver/external/tomcat-webserver-3.2.jar || die
	ln -s "${DISTDIR}"/CE9A1C96875443F2FDD5127B750DA39CF4CE818B-com.trilead.ssh2_1.0.0.build217_r155_v20130603_1628.jar libs.svnClientAdapter.svnkit/external/com.trilead.ssh2_1.0.0.build217_r155_v20130603_1628.jar || die
	ln -s "${DISTDIR}"/89BC047153217F5254506F4C622A771A78883CBC-ValidationAPI.jar swing.validation/external/ValidationAPI.jar || die
	ln -s "${DISTDIR}"/6FC6098C230D7CBA5730106D379CBBB42F6EC48A-validator.jar html.validation/external/validator.jar || die
	ln -s "${DISTDIR}"/64F5BEEADD2A239C4BC354B8DFDB97CF7FDD9983-xmlrpc-client-3.0.jar o.apache.xmlrpc/external/xmlrpc-client-3.0.jar || die
	ln -s "${DISTDIR}"/8FA16AD28B5E79A7CD52B8B72985B0AE8CCD6ADF-xmlrpc-common-3.0.jar o.apache.xmlrpc/external/xmlrpc-common-3.0.jar || die
	ln -s "${DISTDIR}"/D6917BF718583002CBE44E773EE21E2DF08ADC71-xmlrpc-server-3.0.jar o.apache.xmlrpc/external/xmlrpc-server-3.0.jar || die
	ln -s "${DISTDIR}"/C9757EFB2CFBA523A7375A78FA9ECFAF0D0AC505-winp-1.14-patched.jar extexecution.impl/external/winp-1.14-patched.jar || die
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
	java-pkg_jar-from --into libs.json_simple/external json-simple json-simple.jar json-simple-1.1.1.jar

	einfo "Linking in other clusters..."
	mkdir "${S}"/nbbuild/netbeans || die
	pushd "${S}"/nbbuild/netbeans >/dev/null || die

	ln -s /usr/share/netbeans-platform-${SLOT} platform || die
	cat /usr/share/netbeans-platform-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.platform.built

	ln -s /usr/share/netbeans-harness-${SLOT} harness || die
	cat /usr/share/netbeans-harness-${SLOT}/moduleCluster.properties >> moduleCluster.properties || die
	touch nb.cluster.harness.built

	popd >/dev/null || die

	java-pkg_jar-from --build-only --into c.jcraft.jsch/external jsch jsch.jar jsch-0.1.49.jar
	java-pkg_jar-from --build-only --into c.jcraft.jzlib/external jzlib jzlib.jar jzlib-1.0.7.jar
	java-pkg_jar-from --into db.drivers/external jdbc-mysql jdbc-mysql.jar mysql-connector-java-5.1.23-bin.jar
	java-pkg_jar-from --into db.drivers/external jdbc-postgresql jdbc-postgresql.jar postgresql-9.2-1002.jdbc4.jar
	java-pkg_jar-from --build-only --into db.sql.visualeditor/external javacc javacc.jar javacc-3.2.jar
	java-pkg_jar-from --into html.parser/external icu4j-4.4 icu4j.jar icu4j-4_4_2.jar
	java-pkg_jar-from --into html.validation/external iso-relax isorelax.jar isorelax.jar
	java-pkg_jar-from --into html.validation/external log4j log4j.jar log4j-1.2.15.jar
	java-pkg_jar-from --into html.validation/external saxon-9 saxon.jar saxon9B.jar
	# java-pkg_jar-from --into libs.freemarker/external freemarker-2.3 freemarker.jar freemarker-2.3.19.jar
	java-pkg_jar-from --into libs.jvyamlb/external jvyamlb jvyamlb.jar jvyamlb-0.2.3.jar
	java-pkg_jar-from --into libs.lucene/external lucene-3.5 lucene-core.jar lucene-core-3.5.0.jar
	java-pkg_jar-from --into libs.smack/external smack-2.2 smack.jar smack.jar
	java-pkg_jar-from --into libs.smack/external smack-2.2 smackx.jar smackx.jar
	# java-pkg_jar-from --into libs.svnClientAdapter.javahl/external subversion svn-javahl.jar svnjavahl-1.8.4.jar
	java-pkg_jar-from --into libs.xerces/external xerces-2 xercesImpl.jar xerces-2.8.0.jar
	java-pkg_jar-from --build-only --into o.apache.commons.codec/external commons-codec commons-codec.jar apache-commons-codec-1.3.jar
	java-pkg_jar-from --into o.apache.commons.httpclient/external commons-httpclient-3 commons-httpclient.jar commons-httpclient-3.1.jar
	java-pkg_jar-from --into o.apache.commons.lang/external commons-lang-2.1 commons-lang.jar commons-lang-2.4.jar
	java-pkg_jar-from --into o.apache.commons.logging/external commons-logging commons-logging.jar commons-logging-1.1.1.jar
	java-pkg_jar-from --into o.apache.ws.commons.util/external ws-commons-util ws-commons-util.jar ws-commons-util-1.0.1.jar
	java-pkg_jar-from --into servletapi/external tomcat-servlet-api-2.2 servlet.jar servlet-2.2.jar
	java-pkg_jar-from --into xml.jaxb.api/external sun-jaf activation.jar activation.jar
	java-pkg_jar-from --into xml.jaxb.api/external jsr173 jsr173.jar jsr173_1.0_api.jar

	java-pkg-2_src_prepare
}

src_compile() {
	unset DISPLAY
	eant -f ${EANT_BUILD_XML} ${EANT_EXTRA_ARGS} ${EANT_BUILD_TARGET} || die "Compilation failed"
}

src_install() {
	pushd nbbuild/netbeans/ide >/dev/null || die

	insinto ${INSTALL_DIR}

	grep -E "/ide$" ../moduleCluster.properties > "${D}"/${INSTALL_DIR}/moduleCluster.properties || die

	doins -r *
	rm -fr "${D}"/${INSTALL_DIR}/bin/nativeexecution || die
	rm -fr "${D}"/${INSTALL_DIR}/modules/lib || die

	insinto ${INSTALL_DIR}/bin/nativeexecution
	doins bin/nativeexecution/*

	pushd "${D}"/${INSTALL_DIR}/bin/nativeexecution >/dev/null || die
	for file in *.sh ; do
		fperms 755 ${file}
	done
	popd >/dev/null || die

	if use x86 ; then
		doins -r bin/nativeexecution/Linux-x86
		pushd "${D}"/${INSTALL_DIR}/bin/nativeexecution/Linux-x86 >/dev/null || die
		for file in * ; do
			fperms 755 ${file}
		done
		popd >/dev/null || die
	elif use amd64 ; then
		doins -r bin/nativeexecution/Linux-x86_64
		pushd "${D}"/${INSTALL_DIR}/bin/nativeexecution/Linux-x86_64 >/dev/null || die
		for file in * ; do
			fperms 755 ${file}
		done
		popd >/dev/null || die
	fi

	popd >/dev/null || die

	local instdir=${INSTALL_DIR}/modules/ext
	pushd "${D}"/${instdir} >/dev/null || die
	# rm freemarker-2.3.19.jar && dosym /usr/share/freemarker-2.3/lib/freemarker.jar ${instdir}/freemarker-2.3.19.jar || die
	rm icu4j-4_4_2.jar && dosym /usr/share/icu4j-4.4/lib/icu4j.jar ${instdir}/icu4j-4_4_2.jar || die
	rm isorelax.jar && dosym /usr/share/iso-relax/lib/isorelax.jar ${instdir}/isorelax.jar || die
	rm json-simple-1.1.1.jar && dosym /usr/share/json-simple/lib/json-simple.jar ${instdir}/json-simple-1.1.1.jar || die
	rm jvyamlb-0.2.3.jar && dosym /usr/share/jvyamlb/lib/jvyamlb.jar ${instdir}/jvyamlb-0.2.3.jar || die
	rm log4j-1.2.15.jar && dosym /usr/share/log4j/lib/log4j.jar ${instdir}/log4j-1.2.15.jar || die
	rm lucene-core-3.5.0.jar && dosym /usr/share/lucene-3.5/lib/lucene-core.jar ${instdir}/lucene-core-3.5.0.jar || die
	rm mysql-connector-java-5.1.23-bin.jar && dosym /usr/share/jdbc-mysql/lib/jdbc-mysql.jar ${instdir}/mysql-connector-java-5.1.23-bin.jar || die
	rm postgresql-9.2-1002.jdbc4.jar && dosym /usr/share/jdbc-postgresql/lib/jdbc-postgresql.jar ${instdir}/postgresql-9.2-1002.jdbc4.jar || die
	rm saxon9B.jar && dosym /usr/share/saxon-9/lib/saxon.jar ${instdir}/saxon9B.jar || die
	rm servlet-2.2.jar && dosym /usr/share/tomcat-servlet-api-2.2/lib/servlet.jar ${instdir}/servlet-2.2.jar || die
	rm smack.jar && dosym /usr/share/smack-2.2/lib/smack.jar ${instdir}/smack.jar || die
	rm smackx.jar && dosym /usr/share/smack-2.2/lib/smackx.jar ${instdir}/smackx.jar || die
	# rm svnjavahl.jar && dosym /usr/share/subversion/lib/svn-javahl.jar ${instdir}/svnjavahl.jar || die
	rm xerces-2.8.0.jar && dosym /usr/share/xerces-2/lib/xercesImpl.jar ${instdir}/xerces-2.8.0.jar || die
	popd >/dev/null || die

	local instdir=${INSTALL_DIR}/modules/ext/jaxb
	pushd "${D}"/${instdir} >/dev/null || die
	rm activation.jar && dosym /usr/share/sun-jaf/lib/activation.jar ${instdir}/activation.jar || die
	popd >/dev/null || die

	local instdir=${INSTALL_DIR}/modules/ext/jaxb/api
	pushd "${D}"/${instdir} >/dev/null || die
	rm jsr173_1.0_api.jar && dosym /usr/share/jsr173/lib/jsr173.jar ${instdir}/jsr173_1.0_api.jar || die
	popd >/dev/null || die

	dosym ${INSTALL_DIR} /usr/share/netbeans-nb-${SLOT}/ide
}
