# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Tool to change the parameters of a Plextor CD-ROM drive"
HOMEPAGE="http://plextor-tool.sourceforge.net/"
SRC_URI="mirror://sourceforge/plextor-tool/${P}.src.tar.bz2"
S="${WORKDIR}"/${PN}/src

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
)

src_prepare() {
	default

	gunzip plextor-tool.8.gz || die
}

src_compile() {
	local targets="plextor-tool"

	use static && targets="${targets} pt-static"

	echo ${targets} > my-make-targets || die

	emake CC="$(tc-getCC)" ${targets}
}

src_install() {
	local targets=$(<my-make-targets)

	dodoc ../doc/{NEWS,README} TODO
	dobin ${targets}
	doman plextor-tool.8
}
