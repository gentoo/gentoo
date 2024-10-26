# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="ant-contrib:ant-contrib:1.0b6"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

MY_COMMIT="0228412be2ef648cfabc1d74416d3188755aff9b"
DESCRIPTION="Ant-contrib tasks for Apache Ant"
HOMEPAGE="https://ant-contrib.sourceforge.net/"
SRC_URI="https://github.com/cniweb/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64"

# Too many tests fail
RESTRICT="test"

# Common dependencies
# POM: pom.xml
# commons-httpclient:commons-httpclient:3.1 -> >=dev-java/commons-httpclient-3.1:3
# org.apache.ant:ant:1.9.15 -> >=dev-java/ant-core-1.10.9:0
# org.apache.bcel:bcel:5.1 -> >=dev-java/bcel-6.5.0:0
# org.apache.ivy:ivy:2.5.0 -> >=dev-java/ant-ivy-2.5.0:2
# org.jvnet.hudson:ivy:1.4.1 -> !!!groupId-not-found!!!
# xerces:xercesImpl:2.12.0 -> >=dev-java/xerces-2.12.0:2

CDEPEND="
	>=dev-java/ant-1.10.14-r3:0
	dev-java/ant-ivy:0
	dev-java/bcel:0
	dev-java/commons-httpclient:3
	dev-java/xerces:2
"

# Compile dependencies
# POM: pom.xml
# test? junit:junit:4.12 -> >=dev-java/junit-4.12:4
# test? org.apache.ant:ant-launcher:1.9.5 -> >=dev-java/ant-core-1.10.9:0

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/ant-1.10.14-r3:0[junit4]
	)"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

#	JAVA_GENTOO_CLASSPATH="commons-httpclient-3,ant-core,bcel,ant-ivy-2,!!!groupId-not-found!!!,xerces-2"
JAVA_GENTOO_CLASSPATH="commons-httpclient-3,ant,bcel,ant-ivy,xerces-2"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,ant"
JAVA_TEST_SRC_DIR="test/src"
JAVA_TEST_RESOURCE_DIRS="test/resources"

src_prepare() {
	default
	sed -i \
		-e '/^import/s/fr.jayasoft.ivy.ant/org.apache.ivy.ant/' \
		src/main/java/net/sf/antcontrib/net/Ivy14Adapter.java || die
}
