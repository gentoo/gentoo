# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="A GTK+ battery icon which uses libudev to be lightweight and fast"
HOMEPAGE="https://github.com/ColinJones/cbatticon"
SRC_URI="https://github.com/ColinJones/cbatticon/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	x11-libs/libnotify"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	tc-export CC
	emake V=1 VERSION="${PF}"
}

src_install() {
	emake DESTDIR="${D}" V=1 VERSION="${PF}" install
}
