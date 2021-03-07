# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Avalon Framework"
HOMEPAGE="http://avalon.apache.org/"
SRC_URI="mirror://apache/avalon/avalon-framework/source/${P}.src.tar.gz"

LICENSE="Apache-2.0"
SLOT="4.1"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux"
IUSE=""

CDEPEND="dev-java/avalon-logkit:2.0
	dev-java/log4j:0"
RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.4
	${CDEPEND}"

S="${WORKDIR}/${PN}"

java_prepare() {
	cp "${FILESDIR}"/build.xml ./build.xml || die "couldn't copy build.xml"
	local libs="log4j,avalon-logkit-2.0"
	echo "classpath=$(java-pkg_getjars ${libs})" > build.properties
}

src_install() {
	java-pkg_dojar "${S}"/dist/avalon-framework.jar

	use doc && java-pkg_dojavadoc "${S}"/target/docs
	use source && java-pkg_dosrc impl/src/java/*
}
