# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="ia64 instruction set simulator"
HOMEPAGE="https://github.com/trofi/ski http://ski.sourceforge.net/"
SRC_URI="https://github.com/trofi/ski/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug motif"

RDEPEND="
	dev-libs/libltdl:=
	sys-libs/ncurses:=
	virtual/libelf
	debug? ( sys-libs/binutils-libs:= )
	motif? ( x11-libs/motif:= )
"
DEPEND="
	${RDEPEND}
	dev-util/gperf
"
# games-sports/ski and app-emulation/ski both install 'ski' binary, bug #653110
RDEPEND="
	${RDEPEND}
	!games-sports/ski
"

src_configure() {
	# bug #854531
	filter-lto

	local myeconfargs=(
		--without-gtk
		$(use_with motif x11)
		$(use_with debug bfd)
	)

	econf "${myeconfargs[@]}"
}
