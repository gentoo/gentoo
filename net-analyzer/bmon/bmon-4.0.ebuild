# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools linux-info toolchain-funcs

DESCRIPTION="Interface bandwidth monitor"
HOMEPAGE="http://www.infradead.org/~tgr/bmon/ https://github.com/tgraf/bmon/"
SRC_URI="https://codeload.github.com/tgraf/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"

LICENSE="BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ppc64 ~sparc x86"

RDEPEND="
	>=sys-libs/ncurses-5.3-r2:0=
	dev-libs/confuse:=
	dev-libs/libnl:3
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( ChangeLog )

CONFIG_CHECK="~NET_SCHED"
ERROR_NET_SCHED="
	CONFIG_NET_SCHED is not set when it should be.
	Run ${PN} -i proc to use the deprecated proc interface instead.
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.6-docdir-examples.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf CURSES_LIB="$("$(tc-getPKG_CONFIG)" --libs ncurses)"
}
