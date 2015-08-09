# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A standard XML processing API that allows you to stream XML data from and to your application"
HOMEPAGE="http://stax.codehaus.org/"
SRC_URI="http://dist.codehaus.org/${PN}/distributions/${PN}-src-${PV}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4"

#	test? ( dev-java/ant-junit dev-java/ant-trax dev-java/xerces )
DEPEND="
	>=virtual/jdk-1.4
	app-arch/unzip"

S="${WORKDIR}"

src_unpack(){
	unpack ${A}
	cd "${S}" || die "cd failed"
	epatch "${FILESDIR}/1.2.0-build-version.patch"
}

EANT_BUILD_TARGET="ri_bin_dist"

# A lot of these fail and that seems expected based on upstream
# svn logs
RESTRICT="test"

src_test() {
	mkdir lib
	java-ant_rewrite-classpath build.xml
	ANT_TASKS="ant-junit ant-trax" \
		EANT_GENTOO_CLASSPATH="junit,xerces-2" eant test
}

src_install() {
	java-pkg_newjar ${S}/build/stax-api-${PV}.jar stax-api.jar
	java-pkg_newjar ${S}/build/stax-${PV}-dev.jar stax-dev.jar

	if use doc; then
		java-pkg_dojavadoc "${S}/build/javadoc"
	fi
	use source && java-pkg_dosrc src/*
}
