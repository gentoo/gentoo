# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="GTK/VTE based terminal emulator"
HOMEPAGE="https://www.pleyades.net/david/projects/sakura"
SRC_URI="https://launchpad.net/sakura/trunk/${PV}/+download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	>=dev-libs/glib-2.40:2
	x11-libs/gtk+:3[X]
	x11-libs/pango
	x11-libs/vte:2.91"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libX11"
BDEPEND="
	sys-devel/gettext
	>=virtual/perl-podlators-5.10"

PATCHES=(
	"${FILESDIR}"/${PN}-3.8.4-gentoo.patch
)

src_prepare() {
	cmake_src_prepare

	if [[ -v LINGUAS ]]; then
		local lingua
		for lingua in po/*.po; do
			lingua=${lingua#*/}
			lingua=${lingua%.*}
			has ${lingua} ${LINGUAS} || rm po/${lingua}.po || die
		done
	fi
}
