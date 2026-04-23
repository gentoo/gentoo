# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Re-implementations of games for the Linux console."
HOMEPAGE="https://www.muppetlabs.com/~breadbox/software/cgames.html"
SRC_URI="http://www.muppetlabs.com/~breadbox/pub/software/${P}.tar.gz"

IUSE="gpm ncurses"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~ppc64 ~ppc"

DEPEND="
	gpm? ( sys-libs/gpm )
	ncurses? ( sys-libs/ncurses )
"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/no_games_group.patch" \
    "${FILESDIR}/bindir.patch" \
	"${FILESDIR}/int_to_short.patch" \
	"${FILESDIR}/tinfo_link.patch"
)

src_configure() {
	econf \
		$(use_enable gpm mouse) \
		$(use_with ncurses) \
		--prefix="${ED}/usr" \
		--datarootdir="${ED}/usr/share" \
		--mandir="${ED}/usr/share/man"
}
