# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://apache/commons/imaging/source/commons-imaging-1.0-alpha3-src.tar.gz --slot 0 --keywords "~amd64 ~x86" --ebuild commons-imaging-1.0_alpha3.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.commons:commons-imaging:1.0-alpha2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Apache Commons Imaging (previously Sanselan) is a pure-Java image library."
HOMEPAGE="https://commons.apache.org/proper/commons-imaging/"
SRC_URI="mirror://apache/commons/imaging/source/commons-imaging-${PV/_/-}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Compile dependencies
# POM: pom.xml
# test? commons-io:commons-io:2.7 -> >=dev-java/commons-io-2.11.0:1
# test? org.hamcrest:hamcrest:2.2 -> !!!artifactId-not-found!!!
# test? org.junit.jupiter:junit-jupiter:5.6.2 -> !!!groupId-not-found!!!

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( {LICENSE,NOTICE,RELEASE-NOTES}.txt README.md )

S="${WORKDIR}/${P/_/-}-src"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_AUTOMATIC_MODULE_NAME="org.apache.commons.imaging"
