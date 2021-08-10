# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2

DESCRIPTION="Glassfish implementation of persistence API"
HOMEPAGE="https://javaee.github.io/glassfish/"
SRC_URI="https://download.java.net/javaee5/fcs_branch/promoted/source/glassfish-9_0-b48-src.zip"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"

BDEPEND="app-arch/unzip"
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/glassfish"

EANT_BUILD_XML="persistence-api/build.xml"
EANT_BUILD_TARGET="all"

PATCHES=(
	"${FILESDIR}"/${P}-python2.7-sax-parser.patch
)

src_prepare() {
	default
}

src_install() {
	cd "${WORKDIR}"/publish/glassfish || die
	java-pkg_newjar lib/javaee.jar

	insinto /usr/share/${PN}/lib/schemas
	doins lib/schemas/*.xsd
}
