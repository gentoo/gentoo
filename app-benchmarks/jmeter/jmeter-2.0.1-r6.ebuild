# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source examples"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Load test and measure performance on HTTP/FTP services and databases"
HOMEPAGE="http://jmeter.apache.org/"
SRC_URI="mirror://apache/jakarta/jmeter/source/jakarta-${P}_src.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="beanshell"

CDEPEND="
	beanshell? (
		dev-java/bsh:0
	)
	dev-java/bsf:2.3
	dev-java/junit:0
	dev-java/oracle-javamail:0"
DEPEND="virtual/jdk:1.7
	doc? (
		dev-java/velocity:0
	)
	dev-java/ant-nodeps
	sys-apps/sed
	${CDEPEND}"
RDEPEND="virtual/jre:1.7
	${CDEPEND}"

JAVA_ANT_ENCODING="ISO-8859-1"

S=${WORKDIR}/jakarta-${P}

java_prepare() {
	sed -i -e 's/%//g' bin/jmeter || die "Unable to sed."
	cd "${S}/lib" || die
	# FIXME replace all bundled jars bug #63309
	# then rm -f *.jar
	use beanshell && java-pkg_jar-from bsh
	java-pkg_jar-from bsf-2.3
	java-pkg_jar-from junit
	java-pkg_jar-from oracle-javamail
	java-pkg_filter-compiler jikes

	find "${S}"/src -name "*.java" | xargs sed -i -e 's:\benum\b:enumx:g' || die # fix for bug #514662
}

src_compile() {
	local tasks="ant-nodeps"
	use doc && tasks="${tasks} velocity"
	ANT_TASKS="${tasks}" eant package $(use_doc docs-all) || die "compile problem"
}

src_install() {
	diropts --mode=0775
	dodir /opt/${PN}
	local dest="${D}/opt/${PN}/"
	cp -pPR bin/ lib/ "${dest}" || die
	if use doc; then
		cp -pPR printable_docs "${dest}" || die "Failed to install docs"
	fi
	dodoc README

	echo "PATH=\"/opt/${PN}/bin\"" > "${T}/90${PN}" || die
	doenvd "${T}/90${PN}" || die "failed to install env.d file"

	use doc && dohtml -r docs/*
	use source && java-pkg_dosrc src/*
	use examples && java-pkg_doexamples xdocs/demos/*
}
