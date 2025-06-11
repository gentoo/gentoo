# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=${PN%-bin}

DESCRIPTION="A Java/Scala build tool"
HOMEPAGE="https://mill-build.org/"
SRC_URI="
	https://repo1.maven.org/maven2/com/lihaoyi/mill-dist/${PV}/mill-dist-${PV}.jar
		-> ${P}.jar
"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND=">=virtual/jre-11:*"

src_unpack() {
	:
}

src_install() {
	newbin "${DISTDIR}"/${P}.jar ${MY_PN}
}
