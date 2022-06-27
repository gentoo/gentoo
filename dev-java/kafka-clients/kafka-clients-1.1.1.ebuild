# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.kafka:kafka-clients:1.1.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache Kafka distributed event streaming platform"
HOMEPAGE="https://kafka.apache.org/"
SRC_URI="https://archive.apache.org/dist/kafka/${PV}/kafka-${PV}-src.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CP_DEPEND="
	>=dev-java/lz4-java-1.4.1:0
	>=dev-java/slf4j-api-1.7.25:0
	>=dev-java/snappy-1.1.7.1:1.1
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}/kafka-${PV}-src/clients"

JAVA_SRC_DIR="src/main/java"
