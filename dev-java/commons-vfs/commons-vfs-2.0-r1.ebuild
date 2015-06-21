# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-vfs/commons-vfs-2.0-r1.ebuild,v 1.2 2015/06/20 22:58:23 monsieurp Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A single API for accessing various different file systems"
HOMEPAGE="http://commons.apache.org/vfs/"
SRC_URI="mirror://apache/commons/vfs/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"

CDEPEND="
	dev-java/ant-core:0
	dev-java/commons-collections:0
	dev-java/commons-logging:0
	dev-java/commons-net:0
	dev-java/commons-httpclient:3
	dev-java/jackrabbit-webdav:0
	dev-java/jsch:0
	"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

S="${WORKDIR}/${P}/core"

java_prepare() {
	epatch "${FILESDIR}"/${P}-incompatibility.patch

	cp "${FILESDIR}"/${P}-build.xml build.xml || die

	java-ant_rewrite-classpath
	java-ant_ignore-system-classes
}

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

src_install() {
	java-pkg_newjar target/*.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java
}
