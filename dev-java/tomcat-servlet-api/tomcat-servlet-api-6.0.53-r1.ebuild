# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2

MY_A="apache-${P}-src"
MY_P="${MY_A/-servlet-api/}"
DESCRIPTION="Tomcat's Servlet API 2.5/JSP API 2.1 implementation"
HOMEPAGE="https://tomcat.apache.org/"
SRC_URI="https://archive.apache.org/dist/tomcat/tomcat-6/v${PV}/src/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2.5"
KEYWORDS="amd64 ~arm ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=">=virtual/jdk-1.8"
RDEPEND=">=virtual/jre-1.8"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	cp "${FILESDIR}/${SLOT}-build-r1.xml" build.xml || die "Could not replace build.xml"
	rm -r */*/build.xml java/javax/{annotation,ejb,mail,persistence,xml}/ || die
	find -name '*.jar' -delete || die
}

src_install() {
	java-pkg_dojar "${S}"/output/build/lib/*.jar
	use source && java-pkg_dosrc java/javax
}
