# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MAVEN_ID="org.mozilla:rhino:${PV}"
JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5

DESCRIPTION="Rhino JavaScript runtime jar, excludes XML, tools, and ScriptEngine wrapper"
HOMEPAGE="https://github.com/mozilla/rhino"
SRC_URI="https://github.com/mozilla/rhino/archive/Rhino${PV//./_}_Release.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/rhino-Rhino${PV//./_}_Release"

LICENSE="MPL-1.1 GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

# error: package jdk.dynalink does not exist
# error: package jdk.dynalink.linker does not exist
# error: package jdk.dynalink.linker.support does not exist
DEPEND="
	>=virtual/jdk-11
	test? ( dev-java/junit:4 )
"

# rhino/src/main/java/org/mozilla/javascript/Slot.java:29: error: cannot find symbol
#         var newSlot = new Slot(this);
#         ^
#   symbol:   class var
RDEPEND=">=virtual/jre-11:*"

DOCS=( {CODE_OF_CONDUCT,README,RELEASE-NOTES,RELEASE-STEPS}.md {NOTICE-tools,NOTICE}.txt )

JAVA_RESOURCE_DIRS="rhino/src/main/resources"
JAVA_SRC_DIR="rhino/src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4 junit-5"
JAVA_TEST_RESOURCE_DIRS="rhino/src/test/resources"
JAVA_TEST_SRC_DIR=( {rhino/src/test,testutils/src/main}/java )
