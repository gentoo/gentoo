# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.mindrot:jbcrypt:0.4"
JAVA_TESTING_FRAMEWORKS="junit"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java implementation of OpenBSD's Blowfish password hashing code"
HOMEPAGE="https://www.mindrot.org/projects/jBCrypt"
SRC_URI="https://www.mindrot.org/files/jBCrypt/jBCrypt-${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/jBCrypt-${PV}"

JAVA_SRC_DIR="src"
JAVA_TEST_SRC_DIR="test"
JAVA_TEST_GENTOO_CLASSPATH="junit"
