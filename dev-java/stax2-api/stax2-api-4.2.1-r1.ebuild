# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/FasterXML/stax2-api/archive/refs/tags/stax2-api-4.2.1.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild stax2-api-4.2.1.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.codehaus.woodstox:stax2-api:4.2.1"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="stax2 API is an extension to basic Stax 1.0 API"
HOMEPAGE="https://github.com/FasterXML/stax2-api"
SRC_URI="https://github.com/FasterXML/${PN}/archive/refs/tags/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND=">=virtual/jdk-1.9:*"
RDEPEND=">=virtual/jre-1.8:*"

DOCS=( README.md release-notes/VERSION )

S="${WORKDIR}/${PN}-${P}"

JAVA_SRC_DIR=( "src/main/java" "src/moditect" )
JAVA_RESOURCE_DIRS="src/main/resources"

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
