# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="FUSE-based X11 Window-Manager file system"
HOMEPAGE="https://github.com/gerstner-hub/xwmfs"
SRC_URI="https://github.com/gerstner-hub/${PN}/releases/download/v${PV}/${P}-dist.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~x86"
SLOT="0"

RDEPEND="
	sys-fs/fuse:0=
	>=x11-libs/libX11-1.6.5"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_test() {
	# unset display to avoid testing errors, tests rely on X11 and a window
	# manager environment
	unset DISPLAY

	default
}
