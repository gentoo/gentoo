# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 java-ant-2

DESCRIPTION="Generator of classes for accessing the attributes and extensions of JPF plug-ins"
HOMEPAGE="http://jabref.sourceforge.net/"

SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="LGPL-3"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

CDEPEND="dev-java/velocity:0
	dev-java/jpf:1.5"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

# doc target is name="-javadoc" and would need a patch, on demand
EANT_BUILD_TARGET="jars"
EANT_GENTOO_CLASSPATH="jpf-1.5,velocity"
JAVA_ANT_REWRITE_CLASSPATH="true"

src_install() {
	java-pkg_newjar JPFCodeGenerator-${PV}.jar JPFCodeGenerator.jar
	java-pkg_newjar JPFCodeGenerator-${PV}-rt.jar JPFCodeGenerator-rt.jar
	dohtml index.html
}
