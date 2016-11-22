# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Netbeans IDE Cluster"
HOMEPAGE="http://netbeans.org/projects/ide"
SLOT="8.2"
SOURCE_URL="http://download.netbeans.org/netbeans/8.2/final/zip/netbeans-8.2-201609300101-src.zip"
SRC_URI="${SOURCE_URL}
	http://dev.gentoo.org/~fordfrog/distfiles/netbeans-8.2-build.xml.patch.bz2
	http://hg.netbeans.org/binaries/4E74C6BE42FE89871A878C7C4D6158F21A6D8010-antlr-runtime-3.4.jar
	http://hg.netbeans.org/binaries/886FAF4B85054DD6E50D9B3438542F432B5F9251-bytelist-0.1.jar
	http://hg.netbeans.org/binaries/DCDA3604865C8E80789B4F8E8EECC3D4D15D00F8-com.trilead.ssh2_1.0.0.build220_r167_v20150618_1733.jar
	http://hg.netbeans.org/binaries/A8762D07E76CFDE2395257A5DA47BA7C1DBD3DCE-commons-io-1.4.jar
	http://hg.netbeans.org/binaries/0CE1EDB914C94EBC388F086C6827E8BDEEC71AC2-commons-lang-2.6.jar
	http://hg.netbeans.org/binaries/CD0D5510908225F76C5FE5A3F1DF4FA44866F81E-commons-net-3.3.jar
	http://hg.netbeans.org/binaries/901D8F815922C435D985DA3814D20E34CC7622CB-css21-spec.zip
	http://hg.netbeans.org/binaries/83E794DFF9A39401AC65252C8E10157761584224-css3-spec.zip
	http://hg.netbeans.org/binaries/C9A6304FAA121C97CB2458B93D30B1FD6F0F7691-derbysampledb.zip
	http://hg.netbeans.org/binaries/3502EB7D4A72C2C684D23AFC241CCF50797079D1-exechlp-1.0.zip
	http://hg.netbeans.org/binaries/5EEAAC41164FEBCB79C73BEBD678A7B6C10C3E80-freemarker-2.3.19.jar
	http://hg.netbeans.org/binaries/ED727A8D9F247E2050281CB083F1C77B09DCB5CD-guava-15.0.jar
	http://hg.netbeans.org/binaries/23123BB29025254556B6E573023FCDF0F6715A66-html-4.01.zip
	http://hg.netbeans.org/binaries/2541D025F428A361110C4D656CDD99B5C5C5DFCE-html5doc.zip
	http://hg.netbeans.org/binaries/D528B44AE7593D2275927396BF930B28078C5220-htmlparser-1.2.1.jar
	http://hg.netbeans.org/binaries/8E737D82ECAC9BA6100A9BBA71E92A381B75EFDC-ini4j-0.5.1.jar
	http://hg.netbeans.org/binaries/0DCC973606CBD9737541AA5F3E76DED6E3F4D0D0-iri.jar
	http://hg.netbeans.org/binaries/F90E3DA5259DB07F36E6987EFDED647A5231DE76-ispell-enwl-3.1.20.zip
	http://hg.netbeans.org/binaries/ECEAF316A8FAF0E794296EBE158AE110C7D72A5A-JavaEWAH-0.7.9.jar
	http://hg.netbeans.org/binaries/71F434378F822B09A57174AF6C75D37408687C57-jaxb-api.jar
	http://hg.netbeans.org/binaries/27FAE927B5B9AE53A5B0ED825575DD8217CE7042-jaxb-api-doc.zip
	http://hg.netbeans.org/binaries/387BE740EAEF52B3F6E6EE2F140757E7632584CE-jaxb-impl.jar
	http://hg.netbeans.org/binaries/C3787DAB0DDFBD9E98086ED2F219859B0CB77EF7-jaxb-xjc.jar
	http://hg.netbeans.org/binaries/F4DB465F207907A2406B0BF5C8FFEE22A5C3E4E3-jaxb1-impl.jar
	http://hg.netbeans.org/binaries/5E40984A55F6FFF704F05D511A119CA5B456DDB1-jfxrt.jar
	http://hg.netbeans.org/binaries/483A61B688B13C62BB201A683D98A6688B5373B6-jing.jar
	http://hg.netbeans.org/binaries/036FA0032B44AD06A1F13504D97B3685B1C88961-jsch.agentproxy.core-0.0.7.jar
	http://hg.netbeans.org/binaries/9F31964104D71855DF6B73F0C761CDEB3FA3C49C-jsch.agentproxy.sshagent-0.0.7.jar
	http://hg.netbeans.org/binaries/3FA59A536F3DC2197826DC7F224C0823C1534203-jsch.agentproxy.pageant-0.0.7.jar
	http://hg.netbeans.org/binaries/F759114E5A9F9AE907EADB59DBF65189AA399B45-jsch.agentproxy.usocket-jna-0.0.7.jar
	http://hg.netbeans.org/binaries/F406B7784A0DA5C4670B038BF55A4DCD4AF30AEB-jzlib-1.0.7.jar
	http://hg.netbeans.org/binaries/2E07375E5CA3A452472F0E87FB33F243F7A5C08C-libpam4j-1.1.jar
	http://hg.netbeans.org/binaries/AA2671239EBB762FEEE8B908E9F35473A72AFE1B-org.eclipse.core.contenttype_3.4.100.v20110423-0524_nosignature.jar
	http://hg.netbeans.org/binaries/1605B38BB28EAE32C11EAB8F9E238A497754A5B8-org.eclipse.core.jobs-3.5.101_nosignature.jar
	http://hg.netbeans.org/binaries/20800206EB8B490F3CE5BB8AC8A7C3B9E8004A30-org.eclipse.core.net_1.2.100.I20110511-0800_nosignature.jar
	http://hg.netbeans.org/binaries/D2D2105B1E3C9E2FA6240AD088237A57590DDA8D-org.eclipse.core.runtime-3.7.0_nosignature.jar
	http://hg.netbeans.org/binaries/16507EAFDC2B95121AA718895BDB54D616EE4B0F-org.eclipse.core.runtime.compatibility.auth_3.2.200.v20110110_nosignature.jar
	http://hg.netbeans.org/binaries/BD55836AABD558DC643A7844B78866AD990544BC-org.eclipse.equinox.app-1.3.100_nosignature.jar
	http://hg.netbeans.org/binaries/4EE275AE73A140A403903D7E4DBA68C8FBB07001-org.eclipse.equinox.common_3.6.0.v20110523_nosignature.jar
	http://hg.netbeans.org/binaries/B7001D9CC2E2AC4E167D22A13063F0350C71AAA9-org.eclipse.equinox.preferences-3.4.2_nosignature.jar
	http://hg.netbeans.org/binaries/C647079E36A4EB7A24AED2C545E4F0F94194C4D1-org.eclipse.equinox.registry_3.5.200.v20120522-1841_nosignature.jar
	http://hg.netbeans.org/binaries/9267CF311F979078211A70C1B19AF8A8EE71DC8E-org.eclipse.equinox.security-1.1.1_nosignature.jar
	http://hg.netbeans.org/binaries/B580E446B543A8DD2F5AA368B07F9C4C9C2E7029-org.eclipse.jgit-3.6.2.201501210735-r_nosignature.jar
	http://hg.netbeans.org/binaries/244560B99152F3F9BC75DF2D6FAFA8A5216B06B6-org.eclipse.jgit.java7-3.6.2.201501210735-r_nosignature.jar
	http://hg.netbeans.org/binaries/8E2776DE17446EC7450285F19F2C6366117748A8-org.eclipse.mylyn.bugzilla.core_3.17.0.v20150828-2026.jar
	http://hg.netbeans.org/binaries/D4F2BE52B5C048158B5C046C0ACAC3965027FE12-org.eclipse.mylyn.commons.core_3.17.0.v20150625-2042.jar
	http://hg.netbeans.org/binaries/4C753A9D8AB768A55EC99A377A0D22EDA67BAE25-org.eclipse.mylyn.commons.net_3.17.0.v20150706-2057.jar
	http://hg.netbeans.org/binaries/8E52A783A3700FE2F3AED720CBEF6D895C0D5DBC-org.eclipse.mylyn.commons.repositories.core_1.9.0.v20150625-2042.jar
	http://hg.netbeans.org/binaries/50F0A49BDF7C5610E3E602609926065D47A16C6E-org.eclipse.mylyn.commons.xmlrpc_3.17.0.v20150625-2042.jar
	http://hg.netbeans.org/binaries/4F2E28BDB091E2DD215FB9B16C8708513288F16A-org.eclipse.mylyn.tasks.core_3.17.0.v20150828-2026.jar
	http://hg.netbeans.org/binaries/11D1982BE23B06B2721240F424DBEF9F5FDE7F45-org.eclipse.mylyn.wikitext.confluence.core_2.6.0.v20150901-2143.jar
	http://hg.netbeans.org/binaries/A3FEF6144ED1622E4CDD506B9D745527CC675D8D-org.eclipse.mylyn.wikitext.core_2.6.0.v20150901-2143-patched-nosignature.jar
	http://hg.netbeans.org/binaries/825DC870D1D423E347F4F8229A211A2C297BB15D-org.eclipse.mylyn.wikitext.markdown.core_2.6.0.v20150901-2143.jar
	http://hg.netbeans.org/binaries/C3024631DD14008D2FF35A576C3D82AC6FCB2E10-org.eclipse.mylyn.wikitext.textile.core_2.6.0.v20150901-2143.jar
	http://hg.netbeans.org/binaries/17C0C8D6DEBF5EBE734881C131888D8088BD9E7D-org.tmatesoft.svnkit_1.8.12.r10533_v20160129_0158.jar
	http://hg.netbeans.org/binaries/6819C79348FCF4F5125C834E7D3B742582DCA34D-processtreekiller-1.0.7.jar
	http://hg.netbeans.org/binaries/B0D0FCBAC68826D2AFA3C7C89FC4D57B95A000C3-resolver-1.2.jar
	http://hg.netbeans.org/binaries/DAAEFA7A5F3AF75FE4CDC86A1B5904C9F3B5BBF8-svnClientAdapter-javahl-1.10.12.jar
	http://hg.netbeans.org/binaries/C47ED3BCD8CEAECDE3BDEEB7D8D14B577B26F9C8-svnClientAdapter-main-1.10.12.jar
	http://hg.netbeans.org/binaries/AD4A88D99AB7C5B64C8893CA2FF2CBCFCEFC51C8-svnClientAdapter-svnkit-1.10.12.jar
	http://hg.netbeans.org/binaries/5C47A97F05F761F190D87ED5FCBB08D1E05A7FB5-svnjavahl-1.9.3.jar
	http://hg.netbeans.org/binaries/4F94E5B4F14B4571A1D8E37885A3037C91F7C02C-svnkit_1.7.8.r9538_v20130107_2001.jar
	http://hg.netbeans.org/binaries/C0D8A3265D194CC886BAFD585117B6465FD97DCE-swingx-all-1.6.4.jar
	http://hg.netbeans.org/binaries/EDE7FBABD4C96D34E48FDA0E8FECED24C98CEDCA-sqljet-1.1.10.jar
	http://hg.netbeans.org/binaries/CD5B5996B46CB8D96C8F0F89A7A734B3C01F3DF7-tomcat-webserver-3.2.jar
	http://hg.netbeans.org/binaries/89BC047153217F5254506F4C622A771A78883CBC-ValidationAPI.jar
	http://hg.netbeans.org/binaries/15ACB06E2E3A70FC188782BA51369CA81ACFE860-validator.jar
	http://hg.netbeans.org/binaries/C9757EFB2CFBA523A7375A78FA9ECFAF0D0AC505-winp-1.14-patched.jar
	http://hg.netbeans.org/binaries/64F5BEEADD2A239C4BC354B8DFDB97CF7FDD9983-xmlrpc-client-3.0.jar
	http://hg.netbeans.org/binaries/8FA16AD28B5E79A7CD52B8B72985B0AE8CCD6ADF-xmlrpc-common-3.0.jar
	http://hg.netbeans.org/binaries/D6917BF718583002CBE44E773EE21E2DF08ADC71-xmlrpc-server-3.0.jar"
LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}"

CDEPEND="virtual/jdk:1.8
	~dev-java/netbeans-harness-${PV}
	~dev-java/netbeans-platform-${PV}
	>=dev-java/antlr-4.5:4
	dev-java/commons-compress:0
	dev-java/commons-httpclient:3
	dev-java/commons-logging:0
	dev-java/icu4j:55
	dev-java/iso-relax:0
	dev-java/jdbc-mysql:0
	dev-java/jdbc-postgresql:0
	>=dev-java/jsch-0.1.46:0
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
#	dev-java/commons-lang:2.1 fails with "Missing manifest tag OpenIDE-Module"
#	dev-java/freemarker:2.3
#	dev-java/guava:15 fails with "Missing manifest tag OpenIDE-Module"
#	dev-java/ini4j:0 our version is too old
#	dev-java/jaxb:2 upstream version contains more stuff so websvccommon does not compile with ours
#	dev-java/jzlib:0 fails with "Missing manifest tag OpenIDE-Module"
#	dev-java/trilead-ssh2:0 in overlay
DEPEND="${CDEPEND}
	app-arch/unzip
	dev-java/commons-codec:0
	dev-java/javacc:0
	dev-java/javahelp:0
	dev-java/jna:0"
RDEPEND="${CDEPEND}"

INSTALL_DIR="/usr/share/${PN}-${SLOT}"

EANT_BUILD_XML="nbbuild/build.xml"
EANT_BUILD_TARGET="rebuild-cluster"
EANT_EXTRA_ARGS="-Drebuild.cluster.name=nb.cluster.ide -Dext.binaries.downloaded=true -Djava.awt.headless=true -Dpermit.jdk8.builds=true"
EANT_FILTER_COMPILER="ecj-3.3 ecj-3.4 ecj-3.5 ecj-3.6 ecj-3.7"
JAVA_PKG_BSFIX="off"

JAVA_PKG_WANT_SOURCE="1.7"
JAVA_PKG_WANT_TARGET="1.7"

src_unpack() {
	unpack $(basename ${SOURCE_URL})

	einfo "Deleting bundled jars..."
	find -name "*.jar" -type f -delete

	unpack netbeans-8.2-build.xml.patch.bz2

	pushd "${S}" >/dev/null || die
	ln -s "${DISTDIR}"/4E74C6BE42FE89871A878C7C4D6158F21A6D8010-antlr-runtime-3.4.jar libs.antlr3.runtime/external/antlr-runtime-3.4.jar || die
	ln -s "${DISTDIR}"/886FAF4B85054DD6E50D9B3438542F432B5F9251-bytelist-0.1.jar libs.bytelist/external/bytelist-0.1.jar || die
	ln -s "${DISTDIR}"/DCDA3604865C8E80789B4F8E8EECC3D4D15D00F8-com.trilead.ssh2_1.0.0.build220_r167_v20150618_1733.jar libs.svnClientAdapter.svnkit/external/com.trilead.ssh2_1.0.0.build220_r167_v20150618_1733.jar || die
	ln -s "${DISTDIR}"/A8762D07E76CFDE2395257A5DA47BA7C1DBD3DCE-commons-io-1.4.jar o.apache.commons.io/external/commons-io-1.4.jar || die
	ln -s "${DISTDIR}"/0CE1EDB914C94EBC388F086C6827E8BDEEC71AC2-commons-lang-2.6.jar o.apache.commons.lang/external/commons-lang-2.6.jar || die
	ln -s "${DISTDIR}"/CD0D5510908225F76C5FE5A3F1DF4FA44866F81E-commons-net-3.3.jar libs.commons_net/external/commons-net-3.3.jar || die
	ln -s "${DISTDIR}"/901D8F815922C435D985DA3814D20E34CC7622CB-css21-spec.zip css.editor/external/css21-spec.zip || die
	ln -s "${DISTDIR}"/83E794DFF9A39401AC65252C8E10157761584224-css3-spec.zip css.editor/external/css3-spec.zip || die
	ln -s "${DISTDIR}"/C9A6304FAA121C97CB2458B93D30B1FD6F0F7691-derbysampledb.zip derby/external/derbysampledb.zip || die
	ln -s "${DISTDIR}"/3502EB7D4A72C2C684D23AFC241CCF50797079D1-exechlp-1.0.zip dlight.nativeexecution/external/exechlp-1.0.zip || die
	ln -s "${DISTDIR}"/5EEAAC41164FEBCB79C73BEBD678A7B6C10C3E80-freemarker-2.3.19.jar libs.freemarker/external/freemarker-2.3.19.jar || die
	ln -s "${DISTDIR}"/ED727A8D9F247E2050281CB083F1C77B09DCB5CD-guava-15.0.jar c.google.guava/external/guava-15.0.jar || die
	ln -s "${DISTDIR}"/23123BB29025254556B6E573023FCDF0F6715A66-html-4.01.zip html.editor/external/html-4.01.zip || die
	ln -s "${DISTDIR}"/2541D025F428A361110C4D656CDD99B5C5C5DFCE-html5doc.zip html.parser/external/html5doc.zip || die
	ln -s "${DISTDIR}"/D528B44AE7593D2275927396BF930B28078C5220-htmlparser-1.2.1.jar html.parser/external/htmlparser-1.2.1.jar || die
	ln -s "${DISTDIR}"/8E737D82ECAC9BA6100A9BBA71E92A381B75EFDC-ini4j-0.5.1.jar libs.ini4j/external/ini4j-0.5.1.jar || die
	ln -s "${DISTDIR}"/0DCC973606CBD9737541AA5F3E76DED6E3F4D0D0-iri.jar html.validation/external/iri.jar || die
	ln -s "${DISTDIR}"/F90E3DA5259DB07F36E6987EFDED647A5231DE76-ispell-enwl-3.1.20.zip spellchecker.dictionary_en/external/ispell-enwl-3.1.20.zip || die
	ln -s "${DISTDIR}"/ECEAF316A8FAF0E794296EBE158AE110C7D72A5A-JavaEWAH-0.7.9.jar c.googlecode.javaewah.JavaEWAH/external/JavaEWAH-0.7.9.jar || die
	ln -s "${DISTDIR}"/71F434378F822B09A57174AF6C75D37408687C57-jaxb-api.jar xml.jaxb.api/external/jaxb-api.jar || die
	ln -s "${DISTDIR}"/27FAE927B5B9AE53A5B0ED825575DD8217CE7042-jaxb-api-doc.zip libs.jaxb/external/jaxb-api-doc.zip || die
	ln -s "${DISTDIR}"/387BE740EAEF52B3F6E6EE2F140757E7632584CE-jaxb-impl.jar libs.jaxb/external/jaxb-impl.jar || die
	ln -s "${DISTDIR}"/C3787DAB0DDFBD9E98086ED2F219859B0CB77EF7-jaxb-xjc.jar libs.jaxb/external/jaxb-xjc.jar || die
	ln -s "${DISTDIR}"/F4DB465F207907A2406B0BF5C8FFEE22A5C3E4E3-jaxb1-impl.jar libs.jaxb/external/jaxb1-impl.jar || die
	ln -s "${DISTDIR}"/5E40984A55F6FFF704F05D511A119CA5B456DDB1-jfxrt.jar libs.javafx/external/jfxrt.jar || die
	ln -s "${DISTDIR}"/483A61B688B13C62BB201A683D98A6688B5373B6-jing.jar html.validation/external/jing.jar || die
	ln -s "${DISTDIR}"/036FA0032B44AD06A1F13504D97B3685B1C88961-jsch.agentproxy.core-0.0.7.jar libs.jsch.agentproxy/external/jsch.agentproxy.core-0.0.7.jar || die
	ln -s "${DISTDIR}"/9F31964104D71855DF6B73F0C761CDEB3FA3C49C-jsch.agentproxy.sshagent-0.0.7.jar libs.jsch.agentproxy/external/jsch.agentproxy.sshagent-0.0.7.jar || die
	ln -s "${DISTDIR}"/3FA59A536F3DC2197826DC7F224C0823C1534203-jsch.agentproxy.pageant-0.0.7.jar libs.jsch.agentproxy/external/jsch.agentproxy.pageant-0.0.7.jar || die
	ln -s "${DISTDIR}"/F759114E5A9F9AE907EADB59DBF65189AA399B45-jsch.agentproxy.usocket-jna-0.0.7.jar libs.jsch.agentproxy/external/jsch.agentproxy.usocket-jna-0.0.7.jar || die
	ln -s "${DISTDIR}"/F406B7784A0DA5C4670B038BF55A4DCD4AF30AEB-jzlib-1.0.7.jar c.jcraft.jzlib/external/jzlib-1.0.7.jar || die
	ln -s "${DISTDIR}"/2E07375E5CA3A452472F0E87FB33F243F7A5C08C-libpam4j-1.1.jar extexecution.process/external/libpam4j-1.1.jar || die
	ln -s "${DISTDIR}"/AA2671239EBB762FEEE8B908E9F35473A72AFE1B-org.eclipse.core.contenttype_3.4.100.v20110423-0524_nosignature.jar o.eclipse.core.contenttype/external/org.eclipse.core.contenttype_3.4.100.v20110423-0524_nosignature.jar || die
	ln -s "${DISTDIR}"/1605B38BB28EAE32C11EAB8F9E238A497754A5B8-org.eclipse.core.jobs-3.5.101_nosignature.jar o.eclipse.core.jobs/external/org.eclipse.core.jobs-3.5.101_nosignature.jar || die
	ln -s "${DISTDIR}"/20800206EB8B490F3CE5BB8AC8A7C3B9E8004A30-org.eclipse.core.net_1.2.100.I20110511-0800_nosignature.jar o.eclipse.core.net/external/org.eclipse.core.net_1.2.100.I20110511-0800_nosignature.jar || die
	ln -s "${DISTDIR}"/D2D2105B1E3C9E2FA6240AD088237A57590DDA8D-org.eclipse.core.runtime-3.7.0_nosignature.jar o.eclipse.core.runtime/external/org.eclipse.core.runtime-3.7.0_nosignature.jar || die
	ln -s "${DISTDIR}"/16507EAFDC2B95121AA718895BDB54D616EE4B0F-org.eclipse.core.runtime.compatibility.auth_3.2.200.v20110110_nosignature.jar o.eclipse.core.runtime.compatibility.auth/external/org.eclipse.core.runtime.compatibility.auth_3.2.200.v20110110_nosignature.jar || die
	ln -s "${DISTDIR}"/BD55836AABD558DC643A7844B78866AD990544BC-org.eclipse.equinox.app-1.3.100_nosignature.jar o.eclipse.equinox.app/external/org.eclipse.equinox.app-1.3.100_nosignature.jar || die
	ln -s "${DISTDIR}"/4EE275AE73A140A403903D7E4DBA68C8FBB07001-org.eclipse.equinox.common_3.6.0.v20110523_nosignature.jar o.eclipse.equinox.common/external/org.eclipse.equinox.common_3.6.0.v20110523_nosignature.jar || die
	ln -s "${DISTDIR}"/B7001D9CC2E2AC4E167D22A13063F0350C71AAA9-org.eclipse.equinox.preferences-3.4.2_nosignature.jar o.eclipse.equinox.preferences/external/org.eclipse.equinox.preferences-3.4.2_nosignature.jar || die
	ln -s "${DISTDIR}"/C647079E36A4EB7A24AED2C545E4F0F94194C4D1-org.eclipse.equinox.registry_3.5.200.v20120522-1841_nosignature.jar o.eclipse.equinox.registry/external/org.eclipse.equinox.registry_3.5.200.v20120522-1841_nosignature.jar || die
	ln -s "${DISTDIR}"/9267CF311F979078211A70C1B19AF8A8EE71DC8E-org.eclipse.equinox.security-1.1.1_nosignature.jar o.eclipse.equinox.security/external/org.eclipse.equinox.security-1.1.1_nosignature.jar || die
	ln -s "${DISTDIR}"/B580E446B543A8DD2F5AA368B07F9C4C9C2E7029-org.eclipse.jgit-3.6.2.201501210735-r_nosignature.jar o.eclipse.jgit/external/org.eclipse.jgit-3.6.2.201501210735-r_nosignature.jar || die
	ln -s "${DISTDIR}"/244560B99152F3F9BC75DF2D6FAFA8A5216B06B6-org.eclipse.jgit.java7-3.6.2.201501210735-r_nosignature.jar o.eclipse.jgit.java7/external/org.eclipse.jgit.java7-3.6.2.201501210735-r_nosignature.jar || die
	ln -s "${DISTDIR}"/8E2776DE17446EC7450285F19F2C6366117748A8-org.eclipse.mylyn.bugzilla.core_3.17.0.v20150828-2026.jar o.eclipse.mylyn.bugzilla.core/external/org.eclipse.mylyn.bugzilla.core_3.17.0.v20150828-2026.jar || die
	ln -s "${DISTDIR}"/D4F2BE52B5C048158B5C046C0ACAC3965027FE12-org.eclipse.mylyn.commons.core_3.17.0.v20150625-2042.jar o.eclipse.mylyn.commons.core/external/org.eclipse.mylyn.commons.core_3.17.0.v20150625-2042.jar || die
	ln -s "${DISTDIR}"/4C753A9D8AB768A55EC99A377A0D22EDA67BAE25-org.eclipse.mylyn.commons.net_3.17.0.v20150706-2057.jar o.eclipse.mylyn.commons.net/external/org.eclipse.mylyn.commons.net_3.17.0.v20150706-2057.jar || die
	ln -s "${DISTDIR}"/8E52A783A3700FE2F3AED720CBEF6D895C0D5DBC-org.eclipse.mylyn.commons.repositories.core_1.9.0.v20150625-2042.jar o.eclipse.mylyn.commons.repositories.core/external/org.eclipse.mylyn.commons.repositories.core_1.9.0.v20150625-2042.jar || die
	ln -s "${DISTDIR}"/50F0A49BDF7C5610E3E602609926065D47A16C6E-org.eclipse.mylyn.commons.xmlrpc_3.17.0.v20150625-2042.jar o.eclipse.mylyn.commons.xmlrpc/external/org.eclipse.mylyn.commons.xmlrpc_3.17.0.v20150625-2042.jar || die
	ln -s "${DISTDIR}"/4F2E28BDB091E2DD215FB9B16C8708513288F16A-org.eclipse.mylyn.tasks.core_3.17.0.v20150828-2026.jar o.eclipse.mylyn.tasks.core/external/org.eclipse.mylyn.tasks.core_3.17.0.v20150828-2026.jar || die
	ln -s "${DISTDIR}"/11D1982BE23B06B2721240F424DBEF9F5FDE7F45-org.eclipse.mylyn.wikitext.confluence.core_2.6.0.v20150901-2143.jar o.eclipse.mylyn.wikitext.confluence.core/external/org.eclipse.mylyn.wikitext.confluence.core_2.6.0.v20150901-2143.jar || die
	ln -s "${DISTDIR}"/A3FEF6144ED1622E4CDD506B9D745527CC675D8D-org.eclipse.mylyn.wikitext.core_2.6.0.v20150901-2143-patched-nosignature.jar o.eclipse.mylyn.wikitext.core/external/org.eclipse.mylyn.wikitext.core_2.6.0.v20150901-2143-patched-nosignature.jar || die
	ln -s "${DISTDIR}"/825DC870D1D423E347F4F8229A211A2C297BB15D-org.eclipse.mylyn.wikitext.markdown.core_2.6.0.v20150901-2143.jar o.eclipse.mylyn.wikitext.markdown.core/external/org.eclipse.mylyn.wikitext.markdown.core_2.6.0.v20150901-2143.jar || die
	ln -s "${DISTDIR}"/C3024631DD14008D2FF35A576C3D82AC6FCB2E10-org.eclipse.mylyn.wikitext.textile.core_2.6.0.v20150901-2143.jar o.eclipse.mylyn.wikitext.textile.core/external/org.eclipse.mylyn.wikitext.textile.core_2.6.0.v20150901-2143.jar || die
	ln -s "${DISTDIR}"/17C0C8D6DEBF5EBE734881C131888D8088BD9E7D-org.tmatesoft.svnkit_1.8.12.r10533_v20160129_0158.jar libs.svnClientAdapter.svnkit/external/org.tmatesoft.svnkit_1.8.12.r10533_v20160129_0158.jar || die
	ln -s "${DISTDIR}"/6819C79348FCF4F5125C834E7D3B742582DCA34D-processtreekiller-1.0.7.jar extexecution.process/external/processtreekiller-1.0.7.jar || die
	ln -s "${DISTDIR}"/4F94E5B4F14B4571A1D8E37885A3037C91F7C02C-svnkit_1.7.8.r9538_v20130107_2001.jar libs.svnClientAdapter.svnkit/external/svnkit_1.7.8.r9538_v20130107_2001.jar || die
	ln -s "${DISTDIR}"/B0D0FCBAC68826D2AFA3C7C89FC4D57B95A000C3-resolver-1.2.jar o.apache.xml.resolver/external/resolver-1.2.jar || die
	ln -s "${DISTDIR}"/EDE7FBABD4C96D34E48FDA0E8FECED24C98CEDCA-sqljet-1.1.10.jar libs.svnClientAdapter.svnkit/external/sqljet-1.1.10.jar || die
	ln -s "${DISTDIR}"/DAAEFA7A5F3AF75FE4CDC86A1B5904C9F3B5BBF8-svnClientAdapter-javahl-1.10.12.jar libs.svnClientAdapter.javahl/external/svnClientAdapter-javahl-1.10.12.jar || die
	ln -s "${DISTDIR}"/C47ED3BCD8CEAECDE3BDEEB7D8D14B577B26F9C8-svnClientAdapter-main-1.10.12.jar libs.svnClientAdapter/external/svnClientAdapter-main-1.10.12.jar || die
	ln -s "${DISTDIR}"/AD4A88D99AB7C5B64C8893CA2FF2CBCFCEFC51C8-svnClientAdapter-svnkit-1.10.12.jar libs.svnClientAdapter.svnkit/external/svnClientAdapter-svnkit-1.10.12.jar || die
	ln -s "${DISTDIR}"/5C47A97F05F761F190D87ED5FCBB08D1E05A7FB5-svnjavahl-1.9.3.jar libs.svnClientAdapter.javahl/external/svnjavahl-1.9.3.jar || die
	ln -s "${DISTDIR}"/3B91269E9055504778F57744D24F505856698602-svnkit-1.7.0-beta4-20120316.233307-1.jar libs.svnClientAdapter.svnkit/external/svnkit-1.7.0-beta4-20120316.233307-1.jar || die
	ln -s "${DISTDIR}"/015525209A02BD74254930FF844C7C13498B7FB9-svnkit-javahl16-1.7.0-beta4-20120316.233536-1.jar libs.svnClientAdapter.svnkit/external/svnkit-javahl16-1.7.0-beta4-20120316.233536-1.jar || die
	ln -s "${DISTDIR}"/C0D8A3265D194CC886BAFD585117B6465FD97DCE-swingx-all-1.6.4.jar libs.swingx/external/swingx-all-1.6.4.jar || die
	ln -s "${DISTDIR}"/CD5B5996B46CB8D96C8F0F89A7A734B3C01F3DF7-tomcat-webserver-3.2.jar httpserver/external/tomcat-webserver-3.2.jar || die
	ln -s "${DISTDIR}"/89BC047153217F5254506F4C622A771A78883CBC-ValidationAPI.jar swing.validation/external/ValidationAPI.jar || die
	ln -s "${DISTDIR}"/15ACB06E2E3A70FC188782BA51369CA81ACFE860-validator.jar html.validation/external/validator.jar || die
	ln -s "${DISTDIR}"/C9757EFB2CFBA523A7375A78FA9ECFAF0D0AC505-winp-1.14-patched.jar extexecution.process/external/winp-1.14-patched.jar || die
	ln -s "${DISTDIR}"/64F5BEEADD2A239C4BC354B8DFDB97CF7FDD9983-xmlrpc-client-3.0.jar o.apache.xmlrpc/external/xmlrpc-client-3.0.jar || die
	ln -s "${DISTDIR}"/8FA16AD28B5E79A7CD52B8B72985B0AE8CCD6ADF-xmlrpc-common-3.0.jar o.apache.xmlrpc/external/xmlrpc-common-3.0.jar || die
	ln -s "${DISTDIR}"/D6917BF718583002CBE44E773EE21E2DF08ADC71-xmlrpc-server-3.0.jar o.apache.xmlrpc/external/xmlrpc-server-3.0.jar || die
	popd >/dev/null || die
}

src_prepare() {
	einfo "Deleting bundled class files..."
	find -name "*.class" -type f | xargs rm -vf

	epatch netbeans-8.2-build.xml.patch

	einfo "Symlinking external libraries..."
	java-pkg_jar-from --into c.jcraft.jsch/external jsch jsch.jar jsch-0.1.53.jar
	java-pkg_jar-from --into db.drivers/external jdbc-mysql jdbc-mysql.jar mysql-connector-java-5.1.23-bin.jar
	java-pkg_jar-from --into db.drivers/external jdbc-postgresql jdbc-postgresql.jar postgresql-9.4.1209.jar
	java-pkg_jar-from --build-only --into db.sql.visualeditor/external javacc javacc.jar javacc-3.2.jar
	java-pkg_jar-from --into html.parser/external icu4j-55 icu4j.jar icu4j-4_4_2.jar
	java-pkg_jar-from --into html.validation/external iso-relax iso-relax.jar isorelax.jar
	java-pkg_jar-from --into html.validation/external log4j log4j.jar log4j-1.2.15.jar
	java-pkg_jar-from --into html.validation/external saxon-9 saxon.jar saxon9B.jar
	java-pkg_jar-from --build-only --into javahelp/external javahelp jhall.jar jhall-2.0_05.jar
	java-pkg_jar-from --into libs.antlr4.runtime/external antlr-4 antlr-runtime.jar antlr-runtime-4.5.3.jar
	java-pkg_jar-from --into libs.commons_compress/external commons-compress commons-compress.jar commons-compress-1.8.1.jar
	# java-pkg_jar-from --into libs.freemarker/external freemarker-2.3 freemarker.jar freemarker-2.3.19.jar
	java-pkg_jar-from --build-only --into libs.jna/external jna jna.jar jna-4.2.2.jar
	java-pkg_jar-from --into libs.json_simple/external json-simple json-simple.jar json-simple-1.1.1.jar
	java-pkg_jar-from --into libs.jvyamlb/external jvyamlb jvyamlb.jar jvyamlb-0.2.7.jar
	java-pkg_jar-from --into libs.lucene/external lucene-3.5 lucene-core.jar lucene-core-3.5.0.jar
	java-pkg_jar-from --into libs.smack/external smack-2.2 smack.jar smack.jar
	java-pkg_jar-from --into libs.smack/external smack-2.2 smackx.jar smackx.jar
	# java-pkg_jar-from --into libs.svnClientAdapter.javahl/external subversion svn-javahl.jar svnjavahl-1.8.4.jar
	java-pkg_jar-from --into libs.xerces/external xerces-2 xercesImpl.jar xerces-2.8.0.jar
	java-pkg_jar-from --build-only --into o.apache.commons.codec/external commons-codec commons-codec.jar apache-commons-codec-1.3.jar
	java-pkg_jar-from --into o.apache.commons.httpclient/external commons-httpclient-3 commons-httpclient.jar commons-httpclient-3.1.jar
	java-pkg_jar-from --into o.apache.commons.logging/external commons-logging commons-logging.jar commons-logging-1.1.1.jar
	java-pkg_jar-from --into o.apache.ws.commons.util/external ws-commons-util ws-commons-util.jar ws-commons-util-1.0.1.jar
	java-pkg_jar-from --into servletapi/external tomcat-servlet-api-2.2 servlet.jar servlet-2.2.jar
	java-pkg_jar-from --into xml.jaxb.api/external sun-jaf activation.jar activation.jar
	java-pkg_jar-from --into xml.jaxb.api/external jsr173 jsr173.jar jsr173_1.0_api.jar

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

	java-pkg-2_src_prepare
	default
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

	local instdir="${D}"/${INSTALL_DIR}/modules
	pushd "${instdir}" >/dev/null || die
	rm com-jcraft-jsch.jar && java-pkg_jar-from --into "${instdir}" jsch jsch.jar com-jcraft-jsch.jar
	popd >/dev/null || die

	local instdir="${D}"/${INSTALL_DIR}/modules/ext
	pushd "${instdir}" >/dev/null || die
	rm antlr-runtime-4.5.3.jar && java-pkg_jar-from --into "${instdir}" antlr-4 antlr-runtime.jar antlr-runtime-4.5.3.jar
	rm commons-compress-1.8.1.jar && java-pkg_jar-from --into "${instdir}" commons-compress commons-compress.jar commons-compress-1.8.1.jar
	# rm freemarker-2.3.19.jar && dosym /usr/share/freemarker-2.3/lib/freemarker.jar ${instdir}/freemarker-2.3.19.jar || die
	rm icu4j-4_4_2.jar && java-pkg_jar-from --into "${instdir}" icu4j-55 icu4j.jar icu4j-4_4_2.jar
	rm isorelax.jar && java-pkg_jar-from --into "${instdir}" iso-relax iso-relax.jar isorelax.jar
	rm json-simple-1.1.1.jar && java-pkg_jar-from --into "${instdir}" json-simple json-simple.jar json-simple-1.1.1.jar
	rm jvyamlb-0.2.7.jar && java-pkg_jar-from --into "${instdir}" jvyamlb jvyamlb.jar jvyamlb-0.2.7.jar
	rm log4j-1.2.15.jar && java-pkg_jar-from --into "${instdir}" log4j log4j.jar log4j-1.2.15.jar
	rm lucene-core-3.5.0.jar && java-pkg_jar-from --into "${instdir}" lucene-3.5 lucene-core.jar lucene-core-3.5.0.jar
	rm mysql-connector-java-5.1.23-bin.jar && java-pkg_jar-from --into "${instdir}" jdbc-mysql jdbc-mysql.jar mysql-connector-java-5.1.23-bin.jar
	rm postgresql-9.4.1209.jar && java-pkg_jar-from --into "${instdir}" jdbc-postgresql jdbc-postgresql.jar postgresql-9.4.1209.jar
	rm saxon9B.jar && java-pkg_jar-from --into "${instdir}" saxon-9 saxon.jar saxon9B.jar
	rm servlet-2.2.jar && java-pkg_jar-from --into "${instdir}" tomcat-servlet-api-2.2 servlet.jar servlet-2.2.jar
	rm smack.jar && java-pkg_jar-from --into "${instdir}" smack-2.2 smack.jar
	rm smackx.jar && java-pkg_jar-from --into "${instdir}" smack-2.2 smackx.jar
	# rm svnjavahl.jar && dosym /usr/share/subversion/lib/svn-javahl.jar ${instdir}/svnjavahl.jar || die
	rm xerces-2.8.0.jar && java-pkg_jar-from --into "${instdir}" xerces-2 xercesImpl.jar xerces-2.8.0.jar
	popd >/dev/null || die

	local instdir="${D}"/${INSTALL_DIR}/modules/ext/jaxb
	pushd "${instdir}" >/dev/null || die
	rm activation.jar && java-pkg_jar-from --into "${instdir}" sun-jaf activation.jar
	popd >/dev/null || die

	local instdir="${D}"/${INSTALL_DIR}/modules/ext/jaxb/api
	pushd "${instdir}" >/dev/null || die
	rm jsr173_1.0_api.jar && java-pkg_jar-from --into "${instdir}" jsr173 jsr173.jar jsr173_1.0_api.jar
	popd >/dev/null || die

	dosym ${INSTALL_DIR} /usr/share/netbeans-nb-${SLOT}/ide
}
