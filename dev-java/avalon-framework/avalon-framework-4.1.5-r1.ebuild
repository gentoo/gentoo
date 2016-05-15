# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Avalon Framework"
HOMEPAGE="http://avalon.apache.org/"
SRC_URI="mirror://apache/avalon/avalon-framework/source/${P}.src.tar.gz"

LICENSE="Apache-2.0"
SLOT="4.1"
KEYWORDS="amd64 ppc64 x86 ~x86-fbsd"
IUSE=""

COMMON_DEP="
	=dev-java/avalon-logkit-2*
	>=dev-java/log4j-1.2.9"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	cp "${FILESDIR}"/build.xml ./build.xml || die "ANT update failure!"
	local libs="log4j,avalon-logkit-2.0"
	echo "classpath=$(java-pkg_getjars ${libs})" > build.properties
}

src_install() {
	java-pkg_dojar "${S}"/dist/avalon-framework.jar

	use doc && java-pkg_dojavadoc "${S}"/target/docs
	use source && java-pkg_dosrc impl/src/java/*
}
