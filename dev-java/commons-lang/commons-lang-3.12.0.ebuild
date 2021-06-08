# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://mirror.checkdomain.de/apache//commons/lang/source/commons-lang3-3.12.0-src.tar.gz --slot 3.6 --keywords "~amd64 ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris" --ebuild commons-lang-3.12.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.apache.commons:commons-lang3:3.12.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Commons components to manipulate core java classes"
HOMEPAGE="https://commons.apache.org/proper/commons-lang/"
SRC_URI="mirror://apache/commons/lang/source/${PN}3-${PV}-src.tar.gz -> ${P}-sources.tar.gz"
LICENSE="Apache-2.0"
SLOT="3.6"
KEYWORDS="amd64 arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/${PN}3-${PV}-src"

JAVA_ENCODING="ISO-8859-1"

JAVA_SRC_DIR="src/main/java"
