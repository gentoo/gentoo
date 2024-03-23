# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-validator:commons-validator:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Commons component to validate user input, or data input"
HOMEPAGE="https://commons.apache.org/proper/commons-validator/"
SRC_URI="mirror://apache/commons/validator/source/${P}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/validator/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
RESTRICT="test" #839681

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
CP_DEPEND="
	dev-java/commons-beanutils:1.7
	dev-java/commons-digester:2.1
	dev-java/commons-logging:0
"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"
