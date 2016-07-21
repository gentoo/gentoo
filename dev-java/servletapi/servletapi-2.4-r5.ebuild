# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils java-pkg-2 java-ant-2

TC_VERSION="5.5.20"
DESCRIPTION="Servlet API 2.4 from jakarta.apache.org"
HOMEPAGE="http://jakarta.apache.org/"
SRC_URI="http://archive.apache.org/dist/tomcat/tomcat-5/v${TC_VERSION}/src/apache-tomcat-${TC_VERSION}-src.tar.gz"

LICENSE="Apache-1.1"
SLOT="2.4"
KEYWORDS="amd64 ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="doc source"

DEPEND=">=virtual/jdk-1.4
	>=dev-java/ant-core-1.5
	source? ( app-arch/zip )"
RDEPEND=">=virtual/jdk-1.4"

S="${WORKDIR}/apache-tomcat-${TC_VERSION}-src/servletapi"

src_compile() {
	local antflags="jar $(use_doc javadoc examples)"
	eant ${antflags} -f jsr154/build.xml
	eant ${antflags} -f jsr152/build.xml
}

src_install() {
	mv jsr{154,152}/dist/lib/*.jar "${S}"

	if use doc ; then
		mkdir docs
		cd "${S}"/jsr154/build
		mv docs "${S}"/docs/servlet
		mv examples "${S}"/docs/servlet/examples

		cd "${S}"/jsr152/build
		mv docs "${S}"/docs/jsp
		mv examples "${S}"/docs/jsp/examples
	fi

	cd "${S}"
	java-pkg_dojar *.jar
	use doc && java-pkg_dohtml -r docs/*
	use source && java-pkg_dosrc jsr{152,154}/src/share/javax
}
