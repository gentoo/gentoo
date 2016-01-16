# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="XML Schema Object Model (XSOM) allows Java apps to easy parse and inspect XML Schema docs"
HOMEPAGE="https://xsom.dev.java.net/"
# Upstream does not have versioned source bundles :|
SRC_URI="mirror://gentoo/xsom-src-${PV}.tar.bz2"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"

COMMON_DEP="
	dev-java/relaxng-datatype
	dev-java/relaxngcc"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}

	cd "${S}/lib"
	java-pkg_jarfrom relaxng-datatype
	java-pkg_jarfrom relaxngcc

	cd "${S}"
	sed -i \
		-e 's/target name="compile" depends="ngcc,javacc"/target name="compile"/g' \
		-e 's/target name="jar" depends="clean,compile"/target name="jar" depends="compile"/g' \
		build.xml || die "sed failed"

}

src_test() { :; }

src_install() {
	java-pkg_dojar build/xsom.jar

	use doc && java-pkg_dojavadoc build/javadoc
	use source && java-pkg_dosrc src/* build/src/*
}
