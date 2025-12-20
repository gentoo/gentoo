# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A single API for accessing various different file systems"
HOMEPAGE="https://commons.apache.org/vfs/"
SRC_URI="https://archive.apache.org/dist/commons/vfs/source/${P}-src.tar.gz"
S="${WORKDIR}/${P}/core"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ppc64"

CP_DEPEND="
	>=dev-java/ant-1.10.14-r3:0
	dev-java/commons-collections:0
	dev-java/commons-logging:0
	dev-java/commons-net:0
	dev-java/commons-httpclient:3
	dev-java/jackrabbit-webdav:0
	dev-java/jsch:0"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

PATCHES=(
	"${FILESDIR}"/${P}-incompatibility.patch
	"${FILESDIR}"/commons-vfs-2.0-utf8.patch
)

JAVA_RESOURCE_DIRS="resources/src/main/java"
JAVA_SRC_DIR="src/main/java"

# The build.xml is generated from maven and can't run the tests properly
# Use maven test to execute these manually but that means downloading deps from
# the internet. Also the tests need to login to some ftp servers and samba
# shares so I doubt they work for everyone.
#src_test() {
#	ANT_TASKS="ant-junit" eant test
#}

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	mkdir resources || die
	find src/main/java -type f ! -name '*.java' ! -name 'package.html' \
		| xargs cp --parent -t resources || die
}
