# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-pkg-2 java-ant-2

DESCRIPTION="Servlet API 2.3 from jakarta.apache.org"
HOMEPAGE="https://jakarta.apache.org/"
SRC_URI="mirror://gentoo/${P}-20021101.tar.gz"

KEYWORDS="~amd64 ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos ~x64-solaris"
LICENSE="Apache-1.1"
SLOT="2.3"
IUSE="doc source"

DEPEND="
	>=virtual/jdk-1.6
	>=dev-java/ant-core-1.4
	source? ( app-arch/zip )"

RDEPEND="
	>=virtual/jre-1.6"

S="${WORKDIR}/jakarta-servletapi-4"

src_compile() {
	eant all
}

src_install() {
	java-pkg_dojar dist/lib/servlet.jar

	use doc && java-pkg_dohtml -r dist/docs/*
	use source && java-pkg_dosrc src/share/javax
	dodoc dist/README.txt
}
