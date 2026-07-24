# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Ivy is a free java based dependency manager"
HOMEPAGE="https://ant.apache.org/ivy/"
SRC_URI="mirror://apache/ant/ivy/${PV}/apache-ivy-${PV}-src.tar.gz
	verify-sig? ( mirror://apache/ant/ivy/${PV}/apache-ivy-${PV}-src.tar.gz.asc )"
S="${WORKDIR}/apache-ivy-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64"

COMMON_DEPEND="
	>=dev-java/ant-1.10.15-r1:0
	dev-java/bcpg:0
	dev-java/bcprov:0
	dev-java/commons-vfs:2
	dev-java/httpcomponents-client:4
	dev-java/httpcore:0
	dev-java/jakarta-oro:2.0
	dev-java/jsch:0
	dev-java/jsch-agent-proxy:0
"

BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-apache-ant-20260402 )"
DEPEND="
	${COMMON_DEPEND}
	|| ( virtual/jdk:11 virtual/jdk:1.8 )
	test? (
		>=dev-java/ant-1.10.15-r1:0[junit,junit4,testutil]
		>=dev-java/ant-contrib-1.0_beta6_pre20201123-r3:0
		>=dev-java/commons-logging-1.3.6:0
		>=dev-java/hamcrest-3.0:0
		dev-java/xmlunit:1
	)
"

RDEPEND="
	${COMMON_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( NOTICE README.adoc )
PATCHES=(
	"${FILESDIR}/ant-ivy-2.5.3-gentoo.patch"
	"${FILESDIR}/ant-ivy-2.5.3-ant-contrib-classpath.patch"
	"${FILESDIR}/ant-ivy-2.5.3-BundleRepoTest.patch"
	"${FILESDIR}/ant-ivy-2.5.3-testExtendsAbsoluteLocation.patch"
	"${FILESDIR}/ant-ivy-2.5.3-MirroredURLResolverTest.patch"
	"${FILESDIR}/ant-ivy-2.5.3-BintrayResolverTest.patch"
	"${FILESDIR}/ant-ivy-2.5.3-UpdateSiteLoaderTest.patch"
)

JAVA_JAR_FILENAME="ivy.jar" # PN is different
JAVA_SRC_DIR="src/java" # needed for USE=source
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/ant.apache.org.asc"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean ! -path './test/**'
}

src_compile() {
	mkdir lib || die "mkdir lib" # needed because of -Dno.resolve
	local libs="ant,bcpg,bcprov,commons-vfs-2,httpcomponents-client-4,httpcore,jakarta-oro-2.0,jsch,jsch-agent-proxy"
	eant \
		-f build.xml jar $(usev doc javadoc) \
		-Dskip.test \
		-Doffline=true \
		-Dno.resolve=true \
		-Divy.use.local.home=true \
		-Dant.jar=$(java-pkg_getjar --build-only ant ant.jar) \
		-Dgentoo.classpath=$(java-pkg_getjars --build-only "${libs}") \
		-Dant.build.javac.source="$(java-pkg_get-source)" \
		-Dant.build.javac.target="$(java-pkg_get-target)"
}

src_test() {
	# test-class with only one test which needs network access
	rm test/java/org/apache/ivy/osgi/updatesite/UpdateSiteAndIbiblioResolverTest.java || die

	local libs="ant,bcpg,bcprov,commons-vfs-2,httpcomponents-client-4,httpcore,jakarta-oro-2.0,jsch,jsch-agent-proxy"
	libs+=",commons-logging,junit,junit-4,hamcrest,xmlunit-1"
	eant \
		-f build.xml test \
		-Dant-contrib.jar=$(java-pkg_getjars --build-only ant-contrib) \
		-Doffline=true \
		-Dno.resolve=true \
		-Divy.use.local.home=true \
		-Dant.jar=$(java-pkg_getjar --build-only ant ant.jar) \
		-Dgentoo.classpath=$(java-pkg_getjars --build-only "${libs}") \
		-Dant.build.javac.source="$(java-pkg_get-source)" \
		-Dant.build.javac.target="$(java-pkg_get-target)"
}

src_install() {
	if use doc; then
		mkdir target || die
		mv {build/reports,target}/api || die
	fi
	mv {build/artifact/jars/,}ivy.jar || die "rename jar"
	java-pkg-simple_src_install
}
