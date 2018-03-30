# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 java-pkg-2 java-ant-2

DESCRIPTION="Attempt to port pdftk to java"
HOMEPAGE="https://gitlab.com/marcvinyals/pdftk"
#SRC_URI="https://gitlab.com/marcvinyals/pdftk/repository/master/archive.tar.bz2 -> ${P}.tar.bz2"
EGIT_REPO_URI="https://gitlab.com/marcvinyals/pdftk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

JAVA_PKG_STRICT=true
EANT_GENTOO_CLASSPATH="
	bcprov
	commons-lang-3.6
"
JAVA_ANT_REWRITE_CLASSPATH="true"

CDEPEND="dev-java/bcprov:0
	dev-java/commons-lang:3.6"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.7"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.7"

src_install() {
	java-pkg_newjar "build/jar/pdftk.jar"
	java-pkg_dolauncher
}
