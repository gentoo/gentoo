# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Terminfo for foot, a fast, lightweight and minimal Wayland terminal emulator"
HOMEPAGE="https://codeberg.org/dnkl/foot"
SRC_URI="
	https://codeberg.org/dnkl/foot/releases/download/${PV}/foot-${PV}.tar.gz
"
S="${WORKDIR}/${P/-terminfo/}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

RDEPEND="!>=sys-libs/ncurses-6.3[-minimal]"
BDEPEND="sys-libs/ncurses"

src_prepare() {
	default
	sed -i s/@default_terminfo@/foot/ foot.info || die
}

src_install() {
	dodir /usr/share/terminfo/
	tic -xo "${ED}"/usr/share/terminfo foot.info || die
}
