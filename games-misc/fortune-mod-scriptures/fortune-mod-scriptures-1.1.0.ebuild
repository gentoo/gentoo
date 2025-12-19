# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fortune modules from the King James Bible scriptures"
HOMEPAGE="https://scriptures.nephi.org/"
SRC_URI="https://downloads.sourceforge.net/mormon/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc64 ~riscv ~x86"

RDEPEND="games-misc/fortune-mod"

src_install() {
	dodoc README ChangeLog
	insinto /usr/share/fortune
	doins mods/*
}
