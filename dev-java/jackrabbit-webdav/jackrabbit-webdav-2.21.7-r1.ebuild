# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://ftp.halifax.rwth-aachen.de/gentoo/distfiles/3b/jackrabbit-2.21.7-src.zip --slot 0 --keywords "~amd64 ~ppc64 ~x86" --ebuild jackrabbit-webdav-2.21.7.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.jackrabbit:jackrabbit-webdav:2.21.7"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Generic WebDAV Library"
HOMEPAGE="http://jackrabbit.apache.org/jackrabbit-webdav/"
SRC_URI="mirror://apache/jackrabbit/${PV}/jackrabbit-${PV}-src.zip"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86"

# Common dependencies
# POM: pom.xml
# org.apache.httpcomponents:httpclient:4.5.13 -> >=dev-java/commons-httpclient-4.5.13:4
# org.apache.httpcomponents:httpcore:4.4.14 -> >=dev-java/httpcore-4.4.14:0
# org.slf4j:jcl-over-slf4j:1.7.30 -> !!!artifactId-not-found!!!
# org.slf4j:slf4j-api:1.7.30 -> >=dev-java/slf4j-api-1.7.30:0

CDEPEND="
	dev-java/httpcomponents-client:4
	dev-java/httpcore:0
	dev-java/osgi-annotation-versioning:0
	dev-java/slf4j-api:0
"

# Compile dependencies
# POM: pom.xml
# javax.servlet:javax.servlet-api:3.1.0 -> !!!groupId-not-found!!!
# org.osgi:org.osgi.annotation:6.0.0 -> !!!groupId-not-found!!!
# POM: pom.xml
# test? ch.qos.logback:logback-classic:1.2.3 -> !!!groupId-not-found!!!
# test? junit:junit:4.13.2 -> >=dev-java/junit-4.13.2:4

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*
	dev-java/osgi-annotation-versioning:0
	java-virtuals/servlet-api:3.1"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/jackrabbit-${PV}/${PN}"

JAVA_GENTOO_CLASSPATH="httpcomponents-client-4,httpcore,osgi-annotation-versioning,servlet-api-3.1,slf4j-api"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS=( "src/main/resources" "src/main/appended-resources" )

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
