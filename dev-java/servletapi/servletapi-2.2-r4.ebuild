# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Servlet API 2.2 from jakarta.apache.org"
HOMEPAGE="http://jakarta.apache.org/"
SRC_URI="mirror://gentoo/${P}-20021101.tar.gz"

DEPEND="
	>=virtual/jdk-1.6
	dev-java/ant-core:0
	source? ( app-arch/zip )"

RDEPEND="
	>=virtual/jre-1.6"

KEYWORDS="~amd64 ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x64-solaris"
LICENSE="Apache-1.1"
SLOT="2.2"
IUSE="doc"

S="${WORKDIR}/jakarta-servletapi-src"

EANT_BUILD_TARGET="all"

src_prepare() {
	default
	sed -i 's/compile,javadoc/compile/' build.xml || die "sed failed"
}

src_install() {
	einstalldocs
	java-pkg_dojar ../dist/servletapi/lib/servlet.jar
	use doc && java-pkg_dojavadoc ../build/servletapi/docs/api
	use source && java-pkg_dosrc src/share/javax
}
