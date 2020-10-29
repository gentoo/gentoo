# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Linux port of the classical Atari ST game Ballerburg"
HOMEPAGE="http://baller.tuxfamily.org/"
SRC_URI="http://download.tuxfamily.org/baller/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="media-libs/libsdl"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DDOCDIR=share/doc/${PF}
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	gunzip "${ED}usr/share/man/man6/ballerburg.6.gz" || die
}
