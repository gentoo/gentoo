# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Yet another Java library for parsing and writing XML"
HOMEPAGE="http://dev2dev.bea.com/xml/stax.html"
SRC_URI="mirror://gentoo/${P}.jar"

LICENSE="bea.ri.jsr173"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

S="${WORKDIR}"

DOCS=( README.txt jsr173_1.0.pdf )

src_unpack() {
	cd "${S}" || die
	jar xvf "${DISTDIR}/${A}" || die "failed to unpack"
	jar xvf "${P//-/_}_src.jar" || die "failed to unpack"
}

src_prepare() {
	default
	java-pkg_clean
}

src_install() {
	java-pkg-simple_src_install
	use doc && einstalldocs
}
