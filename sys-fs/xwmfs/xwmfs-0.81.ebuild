# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Display and control state of X11 windows and window manager in the file system"
HOMEPAGE="https://github.com/gerstner-hub/xwmfs"
SRC_URI="https://github.com/gerstner-hub/${PN}/releases/download/v${PV}/${P}-dist.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~arm"
SLOT="0"

RDEPEND="sys-fs/fuse:= >=x11-libs/libX11-1.6.5"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
