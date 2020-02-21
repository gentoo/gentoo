# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java Swing layout manager that's powerful and easy to use"
HOMEPAGE="http://www.autel.cz/dmi/tutorial.html"
SRC_URI="mirror://gentoo/${P}.zip"
LICENSE="LGPL-2.1"
SLOT="0"

KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}"

DOCS=( Changes.txt readme.txt )

src_prepare() {
	default
	cd tutorial || die
	for d in *.GIF; do
		mv "${d}" $(basename ${d} .GIF).gif || die
	done
}

src_install() {
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples examples
	einstalldocs
}
