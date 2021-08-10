# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java animation library"
HOMEPAGE="https://kenai.com/projects/trident/pages/Home"
SRC_URI="https://kenai.com/projects/trident/downloads/download/version%20${PV}%20-%20stable/${PN}-all.zip -> ${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RESTRICT="test"

CDEPEND="dev-java/swt:4.10"

DEPEND=">=virtual/jdk-1.8:*
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.8:*
	${CDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/1.3-build.xml.patch
)

S="${WORKDIR}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_BUILD_TARGET="timestamp init clean compile.module.trident jar"
EANT_GENTOO_CLASSPATH="swt-4.10"

src_prepare() {
	default
	mkdir build/classes -p || die
	rm -r src/org/pushingpixels/trident/android/ || die
}

src_compile() {
	EANT_EXTRA_ARGS="-Djdk.home=$(java-config -O)"
	java-pkg-2_src_compile
}

src_install() {
	java-pkg_dojar drop/${PN}.jar

	use source && java-pkg_dosrc src/*
}
