# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.commons:commons-imaging:${PV/_/-}"

inherit java-pkg-2 java-pkg-simple verify-sig

DESCRIPTION="Apache Commons Imaging (previously Sanselan) is a pure-Java image library."
HOMEPAGE="https://commons.apache.org/proper/commons-imaging/"
SRC_URI="mirror://apache/commons/imaging/source/${P/_/-}-src.tar.gz
	verify-sig? ( https://downloads.apache.org/commons/imaging/source/${P/_/-}-src.tar.gz.asc )"
S="${WORKDIR}/${P/_/-}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/commons.apache.org.asc"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-commons )"
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {NOTICE,RELEASE-NOTES}.txt README.md )
PATCHES=( "${FILESDIR}/commons-imaging-1.0_alpha3-PngChunk.javadoc.patch" )

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.imaging"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}
