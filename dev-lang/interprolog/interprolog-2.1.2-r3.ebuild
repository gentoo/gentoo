# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc"

inherit java-pkg-2 java-pkg-simple

MY_P="${PN}$(ver_rs 1- '')"

DESCRIPTION="InterProlog is a Java front-end and enhancement for Prolog"
HOMEPAGE="https://declarativa.com/InterProlog/"
SRC_URI="https://declarativa.com/InterProlog/${MY_P}.zip"
S="${WORKDIR}"/${MY_P}

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

DEPEND="
	dev-java/junit:0
	>=virtual/jdk-1.8:*
	|| (
		dev-lang/xsb
		dev-lang/swi-prolog
		dev-lang/yap )"

RDEPEND=">=virtual/jre-1.8:*"

HTML_DOCS=( INSTALL.htm faq.htm prologAPI.htm )
PATCHES=(
	"${FILESDIR}"/${P}-java1.4.patch
	"${FILESDIR}"/${P}-java17.patch
)

JAVA_CLASSPATH_EXTRA="junit"
JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR="com"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	java-pkg_clean
	rm -r htmldocs || die
	mkdir res || die
	find com -type f ! -name '*.java' \
		| xargs cp --parents -t res || die
}

src_install() {
	java-pkg-simple_src_install

	if use doc ; then
		dodoc -r images
		dodoc PaperEPIA01.doc
	fi
}
