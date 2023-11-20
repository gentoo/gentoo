# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.github.waffle:waffle-jna:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Enable drop-in Windows Single Sign On for popular Java web servers"
HOMEPAGE="https://waffle.github.io/waffle/"
SRC_URI="https://github.com/Waffle/waffle/archive/waffle-parent-${PV}.tar.gz"
S="${WORKDIR}/waffle-waffle-parent-${PV}/Source/JNA/waffle-jna"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" #839681

DEPEND="
	dev-java/caffeine:0
	dev-java/checker-framework-qual:0
	dev-java/jakarta-servlet-api:4
	dev-java/jna:4
	dev-java/slf4j-api:0
	>=virtual/jdk-1.8:*
	test? ( dev-java/junit:5 )
"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="waffle.jna"
JAVA_CLASSPATH_EXTRA="
	caffeine
	checker-framework-qual
	jakarta-servlet-api-4
	jna-4
	slf4j-api
"
JAVA_RESOURCE_DIR="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="
	assertj-core-3
	junit-5
"
JAVA_TEST_SRC_DIR="src/test/java"
