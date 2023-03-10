# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jboss.shrinkwrap:shrinkwrap-api:1.2.6"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Client View of the ShrinkWrap Project"
HOMEPAGE="https://arquillian.org/modules/shrinkwrap-shrinkwrap/"
SRC_URI="https://github.com/shrinkwrap/shrinkwrap/archive/${PV}.tar.gz -> shrinkwrap-${PV}.tar.gz"
S="${WORKDIR}/shrinkwrap-${PV}/api"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

# Restrict to jdk:1.8 - otherwhise one test would fail:
# 1) shouldCreateDefensiveCopyOfURLOnConstruction(org.jboss.shrinkwrap.api.asset.UrlAssetTestCase)
# java.lang.NoSuchMethodException: java.net.URL.set(java.lang.String,java.lang.String,int,java.lang.String,java.lang.String)
#         at java.base/java.lang.Class.getDeclaredMethod(Class.java:2675)
#         at org.jboss.shrinkwrap.api.asset.UrlAssetTestCase.mutateURL(UrlAssetTestCase.java:90)
#         at org.jboss.shrinkwrap.api.asset.UrlAssetTestCase.shouldCreateDefensiveCopyOfURLOnConstruction(UrlAssetTestCase.java:68)
DEPEND="virtual/jdk:1.8"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
