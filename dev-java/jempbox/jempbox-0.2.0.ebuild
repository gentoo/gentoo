# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source test"
WANT_ANT_TASKS="ant-nodeps"
inherit java-pkg-2 java-ant-2

MY_PN="JempBox"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Java library that implements Adobe's XMP specification"
HOMEPAGE="http://www.jempbox.org"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	test? ( dev-java/ant-junit =dev-java/junit-3* )"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	rm -v lib/*.jar
	rm -rf docs/javadoc

	if use test; then
		java-ant_xml-rewrite -f build.xml --change -e junit \
			-a haltonfailure -v true
		cd lib
		java-pkg_jar-from --build-only junit
	else
		# no way to separate building of tests in build.xml
		# at least it doesn't include them in <jar>
		rm -rf src/test
	fi
}

src_compile() {
	eant package $(use_doc)

	#tests delete the jar and javadocs so newjar, dojavadoc will fail to
	#install jar and javadoc.
	mkdir gentoo-dist
	cp "lib/${MY_P}.jar" "gentoo-dist/${MY_P}.jar" || die "Failed to copy jar."
	if use doc; then
		cp -R website/build/site/javadoc gentoo-dist || die \
			"Unable to copy javadoc"
	fi
}

src_test() {
	ANT_TASKS="ant-junit" eant junit
}

src_install() {
	java-pkg_newjar "gentoo-dist/${MY_P}".jar

	if use doc; then
		dohtml -r docs/*
		java-pkg_dojavadoc gentoo-dist/javadoc
	fi

	use source && java-pkg_dosrc src/org
}
