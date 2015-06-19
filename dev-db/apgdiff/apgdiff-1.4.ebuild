# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/apgdiff/apgdiff-1.4.ebuild,v 1.3 2014/08/10 19:56:34 slyfox Exp $

EAPI="5"
JAVA_PKG_IUSE="doc source"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Another PostgreSQL Diff Tool is a simple PostgreSQL diff tool that is useful for schema upgrades"
HOMEPAGE="http://apgdiff.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND=">=virtual/jdk-1.5
	>=dev-java/ant-core-1.7.0:0
	>=dev-java/ant-junit-1.7.0:0
	app-arch/zip:0
	test? (
		dev-java/hamcrest-core:0
		>=dev-java/junit-4.4:4
	)"

RDEPEND=">=virtual/jre-1.5"

java_prepare() {
	mkdir "${S}"/lib
	cd "${S}"/lib
	if use test ; then
		java-pkg_jar-from --build-only hamcrest-core
		java-pkg_jar-from --build-only junit-4
	fi
}

src_compile() {
	eant -Dnoget=true jar $(use_doc)
}

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar
	java-pkg_dolauncher apgdiff --jar ${PN}.jar

	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src/main/java/*
}

src_test() {
	ANT_TASKS="ant-junit" eant -Dnoget=true test
}
