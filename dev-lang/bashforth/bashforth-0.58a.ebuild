# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="String-threaded Forth interpreter in Bash"
HOMEPAGE="https://github.com/ForthHub/ForthFreak"
SRC_URI="http://forthfreak.net/${PN}.versions/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=">app-shells/bash-3.0"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${P}" "${S}"
}

src_install() {
	newbin "${P}" "${PN}"
}
