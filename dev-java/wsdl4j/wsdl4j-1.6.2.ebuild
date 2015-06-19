# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/wsdl4j/wsdl4j-1.6.2.ebuild,v 1.6 2012/12/17 15:44:33 ago Exp $

JAVA_PKG_IUSE="doc source test"

inherit versionator java-pkg-2 java-ant-2

DESCRIPTION="Web Services Description Language for Java Toolkit (WSDL4J)"
HOMEPAGE="http://wsdl4j.sourceforge.net"

TCK="jwsdltck"
TCK_V="1.2"

SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.zip
	test? ( mirror://sourceforge/${TCK}/${TCK}-bin-${TCK_V}.zip )"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~x86-fbsd"

DEPEND=">=virtual/jdk-1.4
	test? ( =dev-java/junit-3.8* )
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${PN}-$(replace_all_version_separators _)"
TCK_S="${WORKDIR}/${TCK}-$(replace_all_version_separators _ ${TCK_V})"

src_unpack() {
	unpack ${A}
	if use test; then
		rm -v "${TCK_S}"/lib/*.jar || die
		epatch "${FILESDIR}/1.6.2-tests-sandbox.patch"
	fi
}

EANT_BUILD_TARGET="compile"
EANT_DOC_TARGET="javadocs"

src_test() {
	ln -s "${TCK_S}" test
	cd "${TCK_S}"
	java-ant_rewrite-classpath
	local junit="$(java-pkg_getjars junit)"
	eant -Dbuild.lib="${S}/test/lib" compile \
		-Dgentoo.classpath="${S}/build/lib/${PN}.jar:${junit}"
	cd "${S}"
	mkdir "${T}/lib"
	ANT_TASKS="ant-junit" eant test -Dtemp.dir="${T}"
}

src_install() {
	java-pkg_dojar build/lib/*.jar

	use doc && java-pkg_dojavadoc build/javadocs/
	use source && java-pkg_dosrc src/*
}
