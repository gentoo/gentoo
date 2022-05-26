# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Speex speech codec library for Java"
HOMEPAGE="http://jspeex.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"
S="${WORKDIR}/${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/ant-core:0"
RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8:*
"
DEPEND="
	${CDEPEND}
	dev-java/junit:0
	>=virtual/jdk-1.8:*
	test? (
		dev-java/ant-junit:0
	)
"
BDEPEND="app-arch/unzip"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="ant-core"
EANT_BUILD_TARGET="package"

PATCHES=(
	"${FILESDIR}"/${P}-remove-junit-report.patch
	"${FILESDIR}"/${P}-remove-proguard-taskdef.patch
)

src_prepare() {
	default

	java-pkg_clean

	cd lib || die
	java-pkg_jar-from --build-only junit
}

src_test() {
	ANT_TASKS="ant-junit ant-core" eant test
}

src_install() {
	java-pkg_dojar dist/${PN}.jar

	dodoc README TODO

	use doc && java-pkg_dojavadoc doc/javadoc
	use source && java-pkg_dosrc src/java/*
}
