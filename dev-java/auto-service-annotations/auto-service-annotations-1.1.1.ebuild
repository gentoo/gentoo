# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.google.auto.service:auto-service-annotations:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Provider-configuration files for ServiceLoader"
HOMEPAGE="https://github.com/google/auto/"
SRC_URI="https://github.com/google/auto/archive/auto-service-${PV}.tar.gz"
S="${WORKDIR}/auto-auto-service-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="com.google.auto.service"
JAVA_SRC_DIR="service/annotations/src/main/java"
