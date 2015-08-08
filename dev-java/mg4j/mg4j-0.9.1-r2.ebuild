# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A free Java implementation of inverted-index compression technique"
SRC_URI="http://mg4j.dsi.unimi.it/${P}-src.tar.gz"
HOMEPAGE="http://mg4j.dsi.unimi.it"

LICENSE="LGPL-2.1"
SLOT="0.9"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

COMMON_DEP="
	dev-java/colt:0
	dev-java/fastutil:4.3
	dev-java/jal:0
	dev-java/java-getopt:1
	dev-java/libreadline-java:0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	dev-java/javacc:0"

java_prepare() {
	epatch "${FILESDIR}/mg4j-build.patch"
}

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_GENTOO_CLASSPATH="colt,fastutil-4.3,jal,java-getopt-1,libreadline-java"

src_install() {
	java-pkg_newjar ${P}.jar

	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc java/it
}
