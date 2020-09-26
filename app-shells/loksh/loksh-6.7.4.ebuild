# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Linux port of OpenBSD's ksh"
HOMEPAGE="https://github.com/dimkr/loksh"
SRC_URI="https://github.com/dimkr/${PN}/releases/download/${PV}/src.tar.xz -> ${P}.tar.xz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="sys-libs/ncurses:0="

RDEPEND="
	${DEPEND}
	!app-shells/ksh
"

S="${WORKDIR}/${PN}"

src_prepare() {
	default
	sed -i "/install_dir/s@loksh@${PF}@" meson.build || die
}

src_configure() {
	# we want it as /bin/ksh
	meson_src_configure --bindir=../bin
}
