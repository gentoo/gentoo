# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="polymorphs bytecode to a printable ASCII string"
HOMEPAGE="http://www.securiteam.com/tools/5MP0L2KFPA.html"
SRC_URI="https://repo.palkeo.com/repositories/mirror7.meh.or.id/Tools/OTHER_TOOLS/ShellCode/${P/-/_}.tgz"
S=${WORKDIR}/${P/-/_}

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
)

src_compile() {
	emake CC="$(tc-getCC)" ${PN}
}

src_install() {
	dobin ${PN}
	dodoc ${PN}.txt
}
