# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-utils-2 java-pkg-2

DESCRIPTION="A Scheme dialect with a simple Java interface called Javadot notation"
HOMEPAGE="http://jscheme.sourceforge.net/jscheme/main.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=virtual/jdk-1.6:*"
RDEPEND=">=virtual/jre-1.6
	${DEPEND}"

src_compile() {
	sh bin/make || die "make failed"
}

src_install() {
	java-pkg_dojar lib/*.jar

	java-pkg_dolauncher ${PN} \
		--main jscheme.REPL

	use doc && dodoc -r doc
}
