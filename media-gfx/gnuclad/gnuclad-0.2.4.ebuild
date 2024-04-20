# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eapi7-ver

DESCRIPTION="Cladogram tree generator mainly used by the GNU/Linux distro timeline project"
HOMEPAGE="https://launchpad.net/gnuclad/"
SRC_URI="http://launchpad.net/gnuclad/trunk/$(ver_cut 1-2)/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="examples"

DEPEND=""
RDEPEND=""

PATCHES=(
	"${FILESDIR}/${P}"-werror.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	doman doc/man/gnuclad.1

	use examples && dodoc -r example
}
