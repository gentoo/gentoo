# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/unbescape/unbescape/archive/unbescape-1.1.6.RELEASE.tar.gz --slot 0 --keywords "~amd64" --ebuild unbescape-1.1.6.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.unbescape:unbescape:1.1.6.RELEASE"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Advanced yet easy-to-use escape/unescape library for Java"
HOMEPAGE="https://www.unbescape.org"
SRC_URI="https://github.com/unbescape/unbescape/archive/unbescape-${PV}.RELEASE.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

S="${WORKDIR}/unbescape-unbescape-${PV}.RELEASE"

JAVA_AUTOMATIC_MODULE_NAME="unbescape"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	default
	sed \
		-e "s/\${pom.version}/${PV}.RELEASE/" \
		-i src/main/resources/org/unbescape/unbescape.properties || die
}
