# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/eclipse-ee4j/mail/archive/2.1.0.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild jakarta-mail-api-2.1.0-r1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="jakarta.mail:jakarta.mail-api:2.1.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Mail API 2.1 Specification API"
HOMEPAGE="https://eclipse-ee4j.github.io/mail/"
SRC_URI="https://github.com/eclipse-ee4j/mail/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0 EPL-2.0 GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Probably caused by --module-path missing @${test_sources}

# warning: [options] system modules path not set in conjunction with -source 9
# src/test/java/module-info.java:24: error: package is empty or does not exist: jakarta.mail.event
#     exports jakarta.mail.event;
#                         ^
# src/test/java/module-info.java:29: error: cannot find symbol
#     uses jakarta.mail.Provider;
#                      ^
#   symbol:   class Provider
#   location: package jakarta.mail
# src/test/java/module-info.java:30: error: cannot find symbol
#     uses jakarta.mail.util.StreamProvider;
#                           ^
#   symbol:   class StreamProvider
#   location: package jakarta.mail.util
# src/test/java/module-info.java:32: error: cannot find symbol
#     provides jakarta.mail.util.StreamProvider with jakarta.mail.util.DummyStreamProvider;
#                               ^
#   symbol:   class StreamProvider
#   location: package jakarta.mail.util
# 4 errors
RESTRICT="test"

DEPEND="
	dev-java/jakarta-activation-api:2
	>=virtual/jdk-11:*
	test? (
		>=dev-java/angus-activation-1.0.0-r1:0
	)"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( ../{CONTRIBUTING,NOTICE,README}.md )

S="${WORKDIR}/mail-${PV}/api"

JAVA_CLASSPATH_EXTRA="jakarta-activation-api-2"
JAVA_SRC_DIR="src/main/"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,angus-activation"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_prepare() {
	default
	java-pkg_clean ..
	java-pkg-2_src_prepare
}
