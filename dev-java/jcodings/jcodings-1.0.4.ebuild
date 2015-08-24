# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
JAVA_PKG_IUSE="source"
inherit base java-pkg-2 java-ant-2

MY_PN="jruby-${PN}"
GIT_PV="0-gbaaab90"

DESCRIPTION="Byte-based encoding support library for Java"
HOMEPAGE="http://jruby.codehaus.org/"
#SRC_URI="https://github.com/jruby/${PN}/tarball/${PV} -> ${P}-git.tar.gz"
SRC_URI="mirror://gentoo/${P}-git.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

EANT_BUILD_TARGET="build"
S="${WORKDIR}/${MY_PN}-${PV}-${GIT_PV}"

src_install() {
	java-pkg_dojar target/${PN}.jar
	use source && java-pkg_dosrc src/*
}
