# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.kafka:kafka-clients:1.1.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache Kafka distributed event streaming platform"
HOMEPAGE="https://kafka.apache.org/"
SRC_URI="https://archive.apache.org/dist/kafka/${PV}/kafka-${PV}-src.tgz"
S="${WORKDIR}/kafka-${PV}-src/clients"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

CP_DEPEND="
	>=dev-java/lz4-java-1.4.1:0
	>=dev-java/slf4j-api-1.7.25:0
	>=dev-java/snappy-java-1.1.10.5-r2:0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

JAVA_SRC_DIR="src/main/java"
