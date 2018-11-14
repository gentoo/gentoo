# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils vcs-snapshot

DESCRIPTION="Lightweight, desktop environment agnostic volume management daemon"
HOMEPAGE="https://github.com/darvid/tudor-volumed"
SRC_URI="https://github.com/darvid/${PN}/tarball/7fc04cb2fb71e6f8815ddd87fd7ef5d02022edeb -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/alsa-lib
	x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

pkg_setup() {
	tc-export CXX
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
}

src_install() {
	dobin ${PN}
}
