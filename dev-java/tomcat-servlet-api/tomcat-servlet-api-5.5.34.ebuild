# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils java-pkg-2 java-ant-2 java-osgi

MY_P="apache-${P/-servlet-api/}-src"
DESCRIPTION="Tomcat's Servlet API 2.4/JSP API 2.0 implementation"
HOMEPAGE="http://tomcat.apache.org/"
SRC_URI="mirror://apache/tomcat/tomcat-5/v${PV/_/-}/src/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2.4"
KEYWORDS="~amd64 ~arm ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc source"

DEPEND=">=virtual/jdk-1.5
	source? ( app-arch/zip )"
RDEPEND=">=virtual/jdk-1.5"

S="${WORKDIR}/${MY_P}/servletapi"

src_compile() {
	local antflags="jar $(use_doc javadoc examples)"
	eant ${antflags} -f jsr154/build.xml
	eant ${antflags} -f jsr152/build.xml
}

src_install() {
	mv jsr{154,152}/dist/lib/*.jar "${S}"

	if use doc ; then
		mkdir docs
		cd "${S}/jsr154/build"
		mv docs "${S}/docs/servlet"
		mv examples "${S}/docs/servlet/examples"

		cd "${S}/jsr152/build"
		mv docs "${S}/docs/jsp"
		mv examples "${S}/docs/jsp/examples"
	fi

	cd "${S}"
	java-osgi_dojar-fromfile --no-auto-version "jsp-api.jar" "${FILESDIR}/jsp-api-2.0-manifest" "Java Server Pages API Bundle"
	java-osgi_dojar-fromfile --no-auto-version "servlet-api.jar" "${FILESDIR}/servlet-api-2.4-manifest" "Servlet API Bundle"
	use doc && java-pkg_dohtml -r docs/*
	use source && java-pkg_dosrc jsr{152,154}/src/share/javax
}
