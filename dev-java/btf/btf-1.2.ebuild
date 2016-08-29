# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Generic interfaces to the classical builder pattern"
HOMEPAGE="https://github.com/fge/btf/"
SRC_URI="https://github.com/fge/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( LGPL-3 Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEP="
	dev-java/jsr305:0
"

RDEPEND="
	${COMMON_DEP}
	>=virtual/jre-1.7
"

DEPEND="
	${COMMON_DEP}
	>=virtual/jdk-1.7
"

JAVA_GENTOO_CLASSPATH="jsr305"

src_install() {
	java-pkg_dojar ${PN}.jar
	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
