# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="The Java Universal Network/Graph Framework"
HOMEPAGE="http://jung.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

COMMON_DEP="dev-java/colt:0
	dev-java/commons-collections"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	dev-java/junit:0
	app-arch/unzip
	${COMMON_DEP}"

PATCHES=( "${FILESDIR}/${P}-build.xml.patch" )

S="${WORKDIR}/src"

java_prepare() {
	epatch ${PATCHES}
	rm -R doc/*
	find "${WORKDIR}" -iname '*.jar' -delete
	find "${WORKDIR}" -iname '*.class' -delete
	java-pkg_jar-from --into ../lib colt
	java-pkg_jar-from --into ../lib commons-collections
	java-pkg_jar-from --build-only --into ../lib junit
}

src_compile() {
	eant -Djardir="../lib" jar $(use_doc)
}

src_install() {
	java-pkg_newjar "${P}.jar"
	use doc && java-pkg_dojavadoc doc
	use source && java-pkg_dosrc edu
}
