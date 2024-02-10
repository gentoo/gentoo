# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools xdg

DESCRIPTION="Vertex icon theme"
HOMEPAGE="https://github.com/horst3180/arc-icon-theme"
SRC_URI="https://github.com/horst3180/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x64-solaris"
# This ebuild does not install any binaries
RESTRICT="binchecks strip"

# Require adwaita until moka is packaged
RDEPEND="x11-themes/adwaita-icon-theme"

src_prepare() {
	default
	eautoreconf
}
