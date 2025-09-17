# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5

DESCRIPTION="Rich and fluent assertions for testing for Java"
HOMEPAGE="https://assertj.github.io/doc/"
SRC_URI="https://github.com/assertj/assertj/archive/assertj-build-${PV}.tar.gz"
S="${WORKDIR}/assertj-assertj-build-${PV}/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# package EngineTestKit does not exist
# package jakarta.ws.rs.core does not exist
# package nl.jqno.equalsverifier does not exist
# package org.hibernate.collection.spi does not exist
# package org.hibernate.engine.spi does not exist
# package org.hibernate.persister.collection does not exist
# package org.junit.jupiter.params.shadow.com.univocity.parsers.common does not exist
# package org.junit.platform.testkit.engine does not exist
# package org.springframework.core.convert does not exist
# package org.springframework.core.convert.support does not exist
# package org.springframework.core does not exist
# package org.springframework.util does not exist
RESTRICT="test" # Needs more stuff to get packaged

CP_DEPEND="
	>=dev-java/byte-buddy-1.17.7:0
	>=dev-java/hamcrest-3.0:0
	dev-java/junit:4
	dev-java/junit:5
	dev-java/opentest4j:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-11:*
	dev-java/apiguardian-api:0
	>=dev-java/asm-9.8-r1:0
	>=dev-java/jna-5.17.0:0
	dev-java/jsr305:0
	test? (
		>=dev-java/commons-collections-4.5.0:4
		>=dev-java/commons-io-2.19.0:0
		>=dev-java/commons-lang-3.18.0:0
		>=dev-java/commons-text-1.14.0:0
		>=dev-java/guava-33.4.8:0
		dev-java/junit-dataprovider:0
		>=dev-java/junit-pioneer-1.9.1:0
		dev-java/memoryfilesystem:0
		>=dev-java/mockito-5.20.0:0
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_CLASSPATH_EXTRA="apiguardian-api asm jna jsr305"
JAVA_INTERMEDIATE_JAR_NAME="org.assertj.core"
JAVA_RELEASE_SRC_DIRS=( ["9"]="src/main/java9" )
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="
	commons-collections-4
	commons-io
	commons-lang
	commons-text
	guava
	junit-5
	junit-pioneer
	mockito
"

JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.{io,lang,math,util}=ALL-UNNAMED )
	fi
}
