# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2

MY_A="apache-${P}-src"
MY_P="${MY_A/-servlet-api/}"
DESCRIPTION="Tomcat's Servlet API 3.0/JSP API 2.2 implementation"
HOMEPAGE="https://tomcat.apache.org/"
SRC_URI="mirror://apache/tomcat/tomcat-7/v${PV}/src/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="3.0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86 ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${MY_P}/"

src_prepare() {
	default

	cp "${FILESDIR}/${SLOT}-build.xml" build.xml || die "Could not replace build.xml"
	rm -fR */*/build.xml ||die
	java-pkg_clean

	java-pkg-2_src_prepare
}

src_install() {
	java-pkg_dojar "${S}"/output/build/lib/*.jar
	use source && java-pkg_dosrc java/javax/servlet/
}
