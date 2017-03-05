# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit java-pkg-2 java-ant-2

MY_P="Acme"

# It proved difficult to recompile the whole Acme package, so we'll only take what we need.

DESCRIPTION="Portions of the Acme collection required for jMol"
HOMEPAGE="http://www.acme.com/"
SRC_URI="http://www.acme.com/resources/classes/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S=${WORKDIR}/${MY_P}

src_prepare() {
	mkdir -p classes
	find . -name \*.class -delete
	java-pkg_filter-compiler jikes
}

src_compile() {
	cp "${FILESDIR}/src.list" "${T}" || die
	ejavac -sourcepath "" -d "${S}/classes" "@${T}/src.list"
	jar cf "${PN}.jar" -C classes . || die "failed to create jar"
}

src_install() {
	java-pkg_dojar ${PN}.jar
}
