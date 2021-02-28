# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2

DESCRIPTION="gcj-free version of pdftk written in Java"
HOMEPAGE="https://gitlab.com/pdftk-java/pdftk"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/pdftk-java/pdftk/"
else
	SRC_URI="https://gitlab.com/pdftk-java/pdftk/-/archive/v${PV}/pdftk-v${PV}.tar.bz2"
	KEYWORDS="~amd64 ~ppc64 ~x86"
	S="${WORKDIR}/pdftk-v${PV}"
fi

LICENSE="GPL-2"
SLOT="0"

JAVA_PKG_STRICT="yes"
EANT_GENTOO_CLASSPATH="bcprov,commons-lang-3.6"
JAVA_ANT_REWRITE_CLASSPATH="true"

CDEPEND="
	dev-java/bcprov:0
	dev-java/commons-lang:3.6"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.8"

src_install() {
	java-pkg_newjar "build/jar/pdftk.jar"
	java-pkg_dolauncher ${PN} --main com.gitlab.pdftk_java.pdftk
}
