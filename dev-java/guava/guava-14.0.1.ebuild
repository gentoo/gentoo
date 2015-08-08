# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A collection of Google's core Java libraries"
HOMEPAGE="http://code.google.com/p/guava-libraries/"
SRC_URI="http://search.maven.org/remotecontent?filepath=com/google/${PN}/${PN}/${PV}/${P}-sources.jar"

LICENSE="Apache-2.0"
SLOT="14"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"

COMMON_DEP="
	dev-java/javax-inject:0
	dev-java/jsr305:0
	java-virtuals/jdk-with-com-sun:0"
RDEPEND="${COMMON_DEP}
	|| ( virtual/jre:1.7 virtual/jre:1.6 )"
DEPEND="${COMMON_DEP}
	app-arch/unzip
	virtual/jdk:1.7" # http://code.google.com/p/guava-libraries/issues/detail?id=635

JAVA_GENTOO_CLASSPATH="jsr305,javax-inject"
