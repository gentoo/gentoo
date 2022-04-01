# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.ivy:ivy:2.5.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple java-osgi

DESCRIPTION="Ivy is a free java based dependency manager"
HOMEPAGE="https://ant.apache.org/ivy/"
SRC_URI="mirror://apache/ant/ivy/${PV}/apache-ivy-${PV}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~ppc64 ~x86"

PROPERTIES="test_network"
RESTRICT="test"

CDEPEND="
	dev-java/ant-core:0
	dev-java/bcpg:0
	dev-java/bcprov:0
	dev-java/httpcomponents-client
	dev-java/commons-vfs:2
	dev-java/httpcore:0
	dev-java/jakarta-oro:2.0
	dev-java/jsch:0
	dev-java/jsch-agent-proxy:0
	test? (
		dev-java/ant-junit:0
		dev-java/ant-junit4:0
		dev-java/ant-junitlauncher:0
		dev-java/ant-testutil:0
		dev-java/hamcrest-core:1.3
		dev-java/hamcrest-library:1.3
		dev-java/xmlunit:1
	)"

# Restrict to jdk:1.8 since java.util.jar.Pack200 was removed.
DEPEND="${CDEPEND}
	virtual/jdk:1.8"
RDEPEND="${CDEPEND}
	virtual/jre:1.8"

DOCS=( LICENSE NOTICE README.adoc )

S="${WORKDIR}/apache-ivy-${PV}"

JAVA_GENTOO_CLASSPATH="ant-core,bcpg,bcprov,httpcomponents-client-4,commons-vfs-2,httpcore,jakarta-oro-2.0,jsch,jsch-agent-proxy"
JAVA_MAIN_CLASS="org.apache.ivy.Main"
JAVA_SRC_DIR="src/java"
JAVA_RESOURCE_DIRS="resources/java"

JAVA_TEST_GENTOO_CLASSPATH="ant-junit,ant-junit4,ant-junitlauncher,ant-testutil,hamcrest-core-1.3,hamcrest-library-1.3,junit-4,xmlunit-1"
JAVA_TEST_SRC_DIR="test-src/java"
JAVA_TEST_RESOURCE_DIRS="test"
JAVA_GENTOO_CLASSPATH_EXTRA="ant-ivy.jar:test.jar:custom-resolver.jar"

# according to 57,60 build-release.xml
# https://github.com/apache/ant-ivy/commit/c0c8df492d2312c983f50cfdc5841e18177f6f7b
JAVA_TEST_EXTRA_ARGS="-Divy.cache.ttl.default=1s -Dskip.download=true -Divy.home=/tmp -D/offline=true"

# Several tests require a certain treatment to "generate-bundles":
# https://github.com/apache/ant-ivy/blob/48234fc5ede85a865eb874a96c08472ce1751fd1/build.xml#L426-L428
# <ant dir="${basedir}/test/test-repo" target="generate-bundles"/>
#
# The procedure is coded in https://github.com/apache/ant-ivy/blob/48234fc5ede85a865eb874a96c08472ce1751fd1/test/test-repo/build.xml#L19-L71
# but appears too difficult to be reprodused with 'java-pkg-simple.eclass'.
# So the failing tests will be excluded, saved for a later attempt.
#
# Not excluding any test classes results in  "Tests run: 1109,  Failures: 98"
# Excluding those test classes listed below leads to "OK (812 tests)"
JAVA_TEST_EXCLUDES=(
	# https://github.com/apache/ant-ivy/blob/083e3f685c1fe29092e59c63b87e81d31fc9babe/build.properties#L56
	# test.class.pattern = *Test
	"org.apache.ivy.ant.testutil.AntTaskTestCase" # not in scope
	"org.apache.ivy.core.TestPerformance" # not in scope
	"org.apache.ivy.util.TestXmlHelper" # not in scope
	"org.apache.ivy.TestFixture" # not in scope
	"org.apache.ivy.TestHelper" # not in scope
	# https://github.com/apache/ant-ivy/blob/48234fc5ede85a865eb874a96c08472ce1751fd1/build.xml#L412-L420
	# <exclude name="**/Abstract*Test.java"/>
	"org.apache.ivy.util.url.AbstractURLHandlerTest"
	"org.apache.ivy.plugins.resolver.AbstractDependencyResolverTest"
	"org.apache.ivy.plugins.matcher.AbstractPatternMatcherTest"
	# following excluded tests cause test failures
	"org.apache.ivy.ant.BuildOBRTaskTest" #                                 Tests run: 3,  Failures: 2
	"org.apache.ivy.core.deliver.DeliverTest" #                             Tests run: 1,  Failures: 1
	"org.apache.ivy.core.module.descriptor.IvyMakePomTest" #                Tests run: 1,  Failures: 1
	"org.apache.ivy.core.settings.XmlSettingsParserTest" #                  Tests run: 29,  Failures: 1
	"org.apache.ivy.osgi.core.AggregatedOSGiResolverTest" #                 Tests run: 3,  Failures: 1
	"org.apache.ivy.osgi.obr.OBRResolverTest" #                             Tests run: 16,  Failures: 16
	"org.apache.ivy.osgi.repo.BundleRepoTest" #                             Tests run: 4,  Failures: 3
	"org.apache.ivy.plugins.parser.m2.PomModuleDescriptorParserTest" #      Tests run: 46,  Failures: 1
	"org.apache.ivy.plugins.parser.xml.XmlModuleDescriptorParserTest" #     Tests run: 44,  Failures: 7
	"org.apache.ivy.plugins.parser.xml.XmlModuleDescriptorWriterTest" #     Tests run: 10,  Failures: 1
	"org.apache.ivy.plugins.parser.xml.XmlModuleUpdaterTest" #              Tests run: 14,  Failures: 3
	"org.apache.ivy.plugins.resolver.JarResolverTest" #                     Tests run: 3,  Failures: 3
	# following excluded tests can pass if run individually
	"org.apache.ivy.ant.IvyConfigureTest" #                                 OK (14 tests)
	"org.apache.ivy.IvyTest" #                                              OK (1 test)
	"org.apache.ivy.MainTest" #                                             OK (12 tests)
	"org.apache.ivy.plugins.report.XmlReportWriterTest" #                   OK (3 tests)
	"org.apache.ivy.plugins.resolver.BintrayResolverTest" #                 OK (12 tests)
	"org.apache.ivy.plugins.resolver.ChainResolverTest" #                   OK (15 tests)
	"org.apache.ivy.plugins.resolver.FileSystemResolverTest" #              OK (27 tests)
	"org.apache.ivy.plugins.resolver.IBiblioMavenSnapshotsResolutionTest" # OK (1 test)
	"org.apache.ivy.plugins.resolver.IvyRepResolverTest" #                  OK (3 tests)
	"org.apache.ivy.plugins.resolver.Maven2LocalTest" #                     OK (2 tests)
	"org.apache.ivy.plugins.resolver.PackagerResolverTest" #                OK (3 tests)
	"org.apache.ivy.plugins.resolver.URLResolverTest" #                     OK (5 tests)
	"org.apache.ivy.plugins.trigger.LogTriggerTest" #                       OK (3 tests)
	# Without PROPERTIES="test_network", the following test cause additional failures.
	"org.apache.ivy.core.settings.OnlineXmlSettingsParserTest"
#	"org.apache.ivy.osgi.updatesite.UpdateSiteAndIbiblioResolverTest"
	"org.apache.ivy.osgi.updatesite.UpdateSiteLoaderTest"
#	"org.apache.ivy.plugins.resolver.IBiblioResolverTest"
#	"org.apache.ivy.plugins.resolver.MirroredURLResolverTest"
	"org.apache.ivy.util.url.ArtifactoryListingTest"
#	"org.apache.ivy.util.url.BasicURLHandlerTest"
#	"org.apache.ivy.util.url.HttpclientURLHandlerTest"
)

src_prepare() {
	default

	mkdir --parents "${JAVA_RESOURCE_DIRS}/META-INF" || die
	pushd "${JAVA_RESOURCE_DIRS}"
		cp "${S}"/{NOTICE,LICENSE} META-INF/ || die
		cp -r "${S}"/src/java/* . || die

		# DEPRECATED: 'ivyconf' element is deprecated, use 'ivysettings' instead
		# according to 210,221 build.xml and still in the upstream .jar file
		cp org/apache/ivy/core/settings/ivy{settings,conf}-local.xml || die
		cp org/apache/ivy/core/settings/ivy{settings,conf}-default-chain.xml || die
		cp org/apache/ivy/core/settings/ivy{settings,conf}-main-chain.xml || die
		cp org/apache/ivy/core/settings/ivy{settings,conf}-public.xml || die
		cp org/apache/ivy/core/settings/ivy{settings,conf}-shared.xml || die
		cp org/apache/ivy/core/settings/ivy{settings,conf}.xml || die

		find . -type f -name '*.java' -exec rm -rf {} + || die
	popd || die
}

src_test() {
	# https://github.com/apache/ant-ivy/blob/48234fc5ede85a865eb874a96c08472ce1751fd1/build.xml#L396-L407
	# name="build-custom-resolver-jar"
	JAVA_SRC_DIR="test/custom-classpath"
	JAVA_JAR_FILENAME="test/java/org/apache/ivy/core/settings/custom-resolver.jar"
	java-pkg-simple_src_compile

	# Without "license.xml" the tests won't even start. "Tests run: 1109,  Failures: 318"
	jar -cf test.jar \
		-C test/java org/apache/ivy/plugins/parser/xml/license.xml \
		-C test/java org/apache/ivy/plugins/parser/m2/license.xml || die

	# Reduce number of failures to "Tests run: 1109,  Failures: 98"
	jar -uf "test.jar" -C test/java . || die

	# Separate *.java files from test resources
	# https://github.com/apache/ant-ivy/blob/48234fc5ede85a865eb874a96c08472ce1751fd1/build.xml#L389-L393
	mkdir test-src || die
	cp -r test/java test-src/ || die
	find test -type f -name '*.java' -exec rm -rf {} + || die

	# https://github.com/apache/ant-ivy/blob/48234fc5ede85a865eb874a96c08472ce1751fd1/build.xml#L430-L438
	# name="prepare-test-jar-repositories"
	mkdir test/jar-repos || die
	jar -cfM "test/jar-repos/jarrepo1.jar" -C test/repositories/1 . || die
#	jar -cfM "test/jar-repos/jarrepo1_subdir.jar" -C test/repositories 1/**/*/ || die

	java-pkg-simple_src_test
}

src_install() {
	default
	java-osgi_dojar-fromfile "ant-ivy.jar" "META-INF/MANIFEST.MF" "ant-ivy"
	use doc && java-pkg_dojavadoc target/api
	use source && java-pkg_dosrc src/*
}
