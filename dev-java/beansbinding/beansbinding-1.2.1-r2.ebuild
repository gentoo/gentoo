# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Implementation of JSR295"
HOMEPAGE="https://java.net/projects/beansbinding/"
SRC_URI="http://dev.gentoo.org/~monsieurp/packages/${P}-src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND=">=virtual/jdk-1.6
	app-arch/unzip"

RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}"

# https://bugs.gentoo.org/show_bug.cgi?id=249740
# Quite weird. Should look into why this is happening.
JAVA_PKG_FILTER_COMPILER="ecj-3.5 ecj-3.4 ecj-3.3 ecj-3.2"

java_prepare() {
	# Avoid the usual "Javadoc returned 1" error.
	java-ant_xml-rewrite \
		-f nbproject/build-impl.xml \
		-c -e javadoc \
		-a failonerror \
		-v "false"
}

src_install() {
	java-pkg_dojar "dist/${PN}.jar"
	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src/*
}
