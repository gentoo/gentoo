# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs vcs-snapshot

DESCRIPTION="Lightweight, desktop environment agnostic volume management daemon"
HOMEPAGE="https://github.com/darvid/tudor-volumed"
SRC_URI="https://github.com/darvid/${PN}/tarball/7fc04cb2fb71e6f8815ddd87fd7ef5d02022edeb -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	media-libs/alsa-lib:=
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=( "${FILESDIR}"/${P}-build.patch )

src_configure() {
	tc-export CXX
}

src_install() {
	dobin ${PN}
}
