# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="${PN^}-XXII"

DESCRIPTION="Chess engine suitable for beginner and intermediate players"
HOMEPAGE="https://phalanx.sourceforge.net/"
SRC_URI="mirror://sourceforge/phalanx/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	local defines=(
		-DGNUFUN
		-D{PBOOK,SBOOK,LEARN}_DIR="'\"${EPREFIX}/usr/share/${PN}\"'"
	)

	local emakeargs=(
		DEFINES="${defines[*]}"
		CC="$(tc-getCC)"
		CFLAGS="${CFLAGS}"
		LDFLAGS="${LDFLAGS}"
	)

	emake "${emakeargs[@]}"
}

src_install() {
	dobin phalanx

	insinto /usr/share/${PN}
	doins {pbook,sbook,learn}.phalanx

	einstalldocs
}
