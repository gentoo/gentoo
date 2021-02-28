# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Hides mouse pointer while not in use (rewrite of unclutter)"
HOMEPAGE="https://github.com/Airblader/unclutter-xfixes"
SRC_URI="https://github.com/Airblader/unclutter-xfixes/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/libev
	x11-libs/libX11
	x11-libs/libXfixes
	x11-libs/libXi
	!x11-misc/unclutter"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	app-text/asciidoc
	virtual/pkgconfig"

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin unclutter
	newman man/${PN}.1 unclutter.1
	einstalldocs
}
