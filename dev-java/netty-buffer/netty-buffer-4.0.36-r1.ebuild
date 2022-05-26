# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/netty/netty/archive/refs/tags/netty-4.0.36.Final.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild netty-buffer-4.0.36.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="io.netty:netty-buffer:4.0.36.Final"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit check-reqs java-pkg-2 java-pkg-simple

DESCRIPTION="Async event-driven framework for high performance network applications"
HOMEPAGE="https://netty.io/"
SRC_URI="https://github.com/netty/netty/archive/refs/tags/netty-${PV}.Final.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

# Common dependencies
# POM: pom.xml
# io.netty:netty-common:4.0.36.Final -> !!!groupId-not-found!!!

CP_DEPEND="dev-java/netty-common:0"

# Compile dependencies
# POM: pom.xml
# test? ch.qos.logback:logback-classic:1.0.13 -> !!!groupId-not-found!!!
# test? io.netty:netty-build:22 -> !!!groupId-not-found!!!
# test? junit:junit:4.12 -> >=dev-java/junit-4.13.2:4
# test? org.easymock:easymock:3.2 -> >=dev-java/easymock-3.3.1:3.2
# test? org.easymock:easymockclassextension:3.2 -> !!!artifactId-not-found!!!
# test? org.hamcrest:hamcrest-library:1.3 -> >=dev-java/hamcrest-library-1.3:1.3
# test? org.javassist:javassist:3.19.0-GA -> !!!groupId-not-found!!!
# test? org.jmock:jmock-junit4:2.6.0 -> !!!groupId-not-found!!!
# test? org.mockito:mockito-core:1.10.8 -> !!!suitable-mavenVersion-not-found!!!

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/easymock:3.2
		dev-java/hamcrest-library:1.3
	)"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( ../{CONTRIBUTING,README}.md ../{LICENSE,NOTICE}.txt )

S="${WORKDIR}/netty-netty-${PV}.Final/buffer/"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,easymock-3.2,hamcrest-library-1.3"
JAVA_TEST_SRC_DIR="src/test/java"

check_env() {
	if use test; then
		# this is needed only for tests
		# https://bugs.gentoo.org/829822
		CHECKREQS_MEMORY="2048M"
		check-reqs_pkg_pretend
	fi
}

pkg_pretend() {
	check_env
}

pkg_setup() {
	check_env
}

src_test() {
	JAVA_TEST_EXTRA_ARGS+=" -Xmx${CHECKREQS_MEMORY}"
	java-pkg-simple_src_test
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
