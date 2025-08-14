# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit eapi9-ver

DESCRIPTION="ia64 instruction set simulator"
HOMEPAGE="https://github.com/trofi/ski"
SRC_URI="https://github.com/trofi/ski/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	sys-libs/ncurses:=
	virtual/libelf:=
	debug? ( sys-libs/binutils-libs:= )
"
DEPEND="
	${RDEPEND}
	dev-util/gperf
"

PATCHES=(
	# merged, to be removed for the next version
	"${FILESDIR}"/${P}-fix_termio.patch
)

src_configure() {
	local myeconfargs=(
		$(use_with debug bfd)
	)

	econf "${myeconfargs[@]}"
}

pkg_postinst() {
	if ver_replacing -le 1.4.0; then
		ewarn "Since version 1.5.0 ${PN} no longer installs xski binary because x11-backend with x11-libs/motif has been removed."
	fi
}
