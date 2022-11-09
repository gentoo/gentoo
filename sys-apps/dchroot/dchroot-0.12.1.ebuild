# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Utility for managing chroots for non-root users"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P/-/_}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="!dev-util/schroot[dchroot]"
BDEPEND="sys-apps/help2man"

PATCHES=(
	"${FILESDIR}"/${P}-make.patch
)

src_prepare() {
	default

	eautoreconf #874318
}
