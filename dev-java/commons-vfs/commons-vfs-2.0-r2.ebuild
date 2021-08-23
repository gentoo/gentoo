# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A single API for accessing various different file systems"
HOMEPAGE="http://commons.apache.org/vfs/"
SRC_URI="mirror://apache/commons/vfs/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ~ppc64 x86 ~amd64-linux ~x86-linux"

CDEPEND="
	dev-java/ant-core:0
	dev-java/commons-collections:0
	dev-java/commons-logging:0
	dev-java/commons-net:0
	dev-java/commons-httpclient:3
	dev-java/jackrabbit-webdav:0
	dev-java/jsch:0"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

PATCHES=(
	"${FILESDIR}"/${P}-incompatibility.patch
)

S="${WORKDIR}/${P}/core"

EANT_GENTOO_CLASSPATH="
	ant-core
	commons-collections
	commons-logging
	commons-net
	commons-httpclient-3
	jackrabbit-webdav
	jsch
"
EANT_EXTRA_ARGS="-Dlibdir=${T}"

# The build.xml is generated from maven and can't run the tests properly
# Use maven test to execute these manually but that means downloading deps from
# the internet. Also the tests need to login to some ftp servers and samba
# shares so I doubt they work for everyone.
#src_test() {
#	ANT_TASKS="ant-junit" eant test
#}

src_prepare() {
	default
	cp "${FILESDIR}"/${P}-build.xml build.xml || die

	java-ant_rewrite-classpath
	java-ant_ignore-system-classes
}

src_install() {
	java-pkg_newjar target/*.jar

	# [javadoc] No javadoc created, no need to post-process anything
#	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java
}
