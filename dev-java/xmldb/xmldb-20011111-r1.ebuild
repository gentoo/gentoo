# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 eutils java-ant-2

MY_PN="${PN}-api"
MY_PV="11112001"
MY_P="${MY_PN}-${MY_PV}"
DESCRIPTION="Java implementation for specifications made by XML:DB"
HOMEPAGE="http://sourceforge.net/projects/xmldb-org/"
SRC_URI="mirror://sourceforge/xmldb-org/${MY_P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

# TODO please make compiling the junit tests optional
COMMON_DEP="
	>=dev-java/xerces-2.7
	>=dev-java/xalan-2.7
	=dev-java/junit-3.8*"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -v *.jar || die
	mkdir lib

	epatch "${FILESDIR}/${P}-unreachable.patch"

	mkdir src && mv org src
	cp "${FILESDIR}/build-${PV}.xml" build.xml
}

src_compile() {
	# --with-dependencies because of indirectly referenced xml-commons-external
	eant jar $(use_doc) \
		-Dclasspath=$(java-pkg_getjars --with-dependencies xerces-2,xalan,junit)
}

src_install() {
	java-pkg_dojar dist/*.jar

	use doc && java-pkg_dojavadoc dist/doc/api
	use source && java-pkg_dosrc src/*
}
