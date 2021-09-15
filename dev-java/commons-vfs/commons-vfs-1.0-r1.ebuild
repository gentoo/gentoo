# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"
MAVEN_ID="commons-vfs:commons-vfs:1.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A single Java API for accessing various different file systems"
HOMEPAGE="https://commons.apache.org/vfs/"
SRC_URI="https://archive.apache.org/dist/${PN/-//}/source/${P}-src.tar.gz" # Not on Apache mirrors.
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux"
RESTRICT="test" # Some failures, can't figure them out.

CP_DEPEND="
	dev-java/ant-core:0
	dev-java/commons-collections:0
	dev-java/commons-httpclient:3
	dev-java/commons-logging:0
	dev-java/commons-net:0
	dev-java/jsch:0
"

RDEPEND=">=virtual/jre-1.7
	${CP_DEPEND}"

DEPEND=">=virtual/jdk-1.7
	${CP_DEPEND}"

S="${WORKDIR}/${P}-src"
JAVA_SRC_DIR="core/src/main"

src_install() {
	java-pkg-simple_src_install
	dodoc {NOTICE,RELEASE_NOTES}.txt
}
