# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://sourceforge/project/spin/spin/v1.5/spin-1.5-all.zip --slot 0 --keywords "~amd64 ~x86" --ebuild spin-1.5-r2.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="spin:spin:1.5"
JAVA_TESTING_FRAMEWORKS="junit"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Transparent threading solution for non-freezing Swing applications."
HOMEPAGE="http://spin.sourceforge.net"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/v${PV}/${P}-all.zip"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Common dependencies
# POM: pom.xml
# cglib:cglib-nodep:2.1_3 -> !!!artifactId-not-found!!!

CP_DEPEND="
	dev-java/cglib:3
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

BDEPEND="app-arch/unzip"

DOCS=( license.txt )

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/java"

src_test() {
	# 1) testEDTNotBlockedDuringInvocation(spin.off.SpinOffTest)java.lang.Error:
	# Unable to make void java.awt.EventDispatchThread.pumpEvents(java.awt.Conditional) accessible:
	# module java.desktop does not "opens java.awt" to unnamed module @42bb2aee

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge "17" ; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.desktop/java.awt=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
	fi

	# There was 1 error:
	# 1) testNonAccessibleInterface(spin.JDKProxyFactoryTest)java.awt.HeadlessException
	#         at java.desktop/java.awt.GraphicsEnvironment.checkHeadless(GraphicsEnvironment.java:166)
	#         at java.desktop/java.awt.Window.<init>(Window.java:553)
	#         at java.desktop/java.awt.Frame.<init>(Frame.java:428)
	#         at java.desktop/java.awt.Frame.<init>(Frame.java:393)
	#         at java.desktop/javax.swing.JFrame.<init>(JFrame.java:180)
	#         at spin.JDKProxyFactoryTest$1.<init>(JDKProxyFactoryTest.java:44)
	#         at spin.JDKProxyFactoryTest.testNonAccessibleInterface(JDKProxyFactoryTest.java:44)
	#         at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	#         at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:77)
	#         at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)

	# JAVA_TEST_RUN_ONLY="spin.JDKProxyFactoryTest"
	# java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY="spin.CGLibProxyFactoryTest"
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY="spin.off.AWTReflectDispatcherTest"
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY="spin.off.SpinOffTest"
	java-pkg-simple_src_test
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
