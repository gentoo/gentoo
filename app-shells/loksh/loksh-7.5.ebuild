# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Linux port of OpenBSD's ksh"
HOMEPAGE="https://github.com/dimkr/loksh"
SRC_URI="https://github.com/dimkr/loksh/releases/download/${PV}/${P}.tar.xz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

DEPEND="sys-libs/ncurses"
RDEPEND="
	${DEPEND}
	!app-shells/ksh
"

src_prepare() {
	default
	sed -i "/install_dir/s@loksh@${PF}@" meson.build || die
}

src_configure() {
	# we want it as /bin/ksh
	meson_src_configure --bindir=../bin
}
