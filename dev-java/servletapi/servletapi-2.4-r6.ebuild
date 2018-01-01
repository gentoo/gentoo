# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils java-pkg-2 java-ant-2

TC_VERSION="5.5.20"
DESCRIPTION="Servlet API 2.4 from jakarta.apache.org"
HOMEPAGE="https://jakarta.apache.org/"
SRC_URI="https://archive.apache.org/dist/tomcat/tomcat-5/v${TC_VERSION}/src/apache-tomcat-${TC_VERSION}-src.tar.gz"

SLOT="2.4"
KEYWORDS="~amd64 ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
LICENSE="Apache-1.1"
IUSE="doc source"

DEPEND="
	>=virtual/jdk-1.6
	dev-java/ant-core:0
	source? ( app-arch/zip )"

RDEPEND="
	>=virtual/jdk-1.4"

S="${WORKDIR}/apache-tomcat-${TC_VERSION}-src/servletapi"

src_compile() {
	local antflags="jar $(use_doc javadoc examples)"
	eant ${antflags} -f jsr154/build.xml
	eant ${antflags} -f jsr152/build.xml
}

src_install() {
	mv jsr{154,152}/dist/lib/*.jar "${S}" || die

	if use doc; then
		mkdir docs || die
		cd "${S}"/jsr154/build || die
		mv docs "${S}"/docs/servlet || die
		mv examples "${S}"/docs/servlet/examples || die

		cd "${S}"/jsr152/build || die
		mv docs "${S}"/docs/jsp || die
		mv examples "${S}"/docs/jsp/examples || die
	fi

	cd "${S}" || die
	java-pkg_dojar *.jar
	use doc && java-pkg_dohtml -r docs/*
	use source && java-pkg_dosrc jsr{152,154}/src/share/javax
}
