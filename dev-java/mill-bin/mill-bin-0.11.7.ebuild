# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=${PN%-bin}

DESCRIPTION="A Java/Scala build tool"
HOMEPAGE="https://com-lihaoyi.github.io/mill/"
SRC_URI="https://github.com/com-lihaoyi/${MY_PN}/releases/download/${PV}/${PV}-assembly -> ${P}"
KEYWORDS="~amd64 ~x86"

LICENSE="MIT"
SLOT="0"

RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}"

src_unpack() {
	:
}

src_install() {
	newbin "${DISTDIR}"/${P} ${MY_PN}
}
