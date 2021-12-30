# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://apache/commons/jxpath/source/commons-jxpath-1.3-src.tar.gz --slot 0 --keywords "~amd64 ~ppc64 ~x86" --ebuild commons-jxpath-1.3-r5.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="commons-jxpath:commons-jxpath:1.3"
# Tests depend on mockrunner-jdk1.3-j2ee1 which we don't have
# JAVA_TESTING_FRAMEWORKS="junit"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Applies XPath expressions to graphs of objects of all kinds"
HOMEPAGE="https://commons.apache.org/jxpath/"
SRC_URI="mirror://apache/commons/jxpath/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

# Common dependencies
# POM: pom.xml
# commons-beanutils:commons-beanutils:1.7.0 -> >=dev-java/commons-beanutils-1.9.4:1.7
# jdom:jdom:1.0 -> !!!groupId-not-found!!!

CP_DEPEND="
	dev-java/commons-beanutils:1.7
	dev-java/jdom:0
	java-virtuals/servlet-api:3.0
"

# Compile dependencies
# POM: pom.xml
# javax.servlet:jsp-api:2.0 -> !!!groupId-not-found!!!
# javax.servlet:servlet-api:2.4 -> !!!groupId-not-found!!!
# xerces:xercesImpl:2.4.0 -> >=dev-java/xerces-2.12.0:2
# xml-apis:xml-apis:1.3.04 -> !!!groupId-not-found!!!
# POM: pom.xml
# test? com.mockrunner:mockrunner-jdk1.3-j2ee1.3:0.4 -> !!!groupId-not-found!!!
# test? junit:junit:3.8.1 -> >=dev-java/junit-3.8.2:0

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	dev-java/xerces:2"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( {LICENSE,NOTICE}.txt )

S="${WORKDIR}/${P}-src"

JAVA_CLASSPATH_EXTRA="xerces-2"
JAVA_SRC_DIR="src/java"

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
