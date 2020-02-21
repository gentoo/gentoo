# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Web Services Description Language for Java Toolkit (WSDL4J)"
HOMEPAGE="http://wsdl4j.sourceforge.net"

TCK="jwsdltck"
TCK_V="1.2"

SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.zip
	test? ( mirror://sourceforge/${TCK}/${TCK}-bin-${TCK_V}.zip )"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
# tests fail with encoding errors
RESTRICT="test"

DEPEND=">=virtual/jdk-1.4
	test? ( dev-java/junit:0 )
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${P//./_}"
TCK_S="${WORKDIR}/${TCK}-${TCK_V//./_}"

EANT_BUILD_TARGET="compile"
EANT_DOC_TARGET="javadocs"

src_prepare() {
	default
	if use test; then
		rm -v "${TCK_S}"/lib/*.jar || die
		eapply "${FILESDIR}/1.6.2-tests-sandbox.patch"
	fi
}

src_test() {
	ln -s "${TCK_S}" test || die
	cd "${TCK_S}" || die
	java-ant_rewrite-classpath
	local junit="$(java-pkg_getjars junit)"
	eant -Dbuild.lib="${S}/test/lib" compile \
		-Dgentoo.classpath="${S}/build/lib/${PN}.jar:${junit}"
	cd "${S}" || die
	mkdir "${T}/lib" || die
	ANT_TASKS="ant-junit" eant test -Dtemp.dir="${T}"
}

src_install() {
	java-pkg_dojar build/lib/*.jar

	use doc && java-pkg_dojavadoc build/javadocs/
	use source && java-pkg_dosrc src/*
}
