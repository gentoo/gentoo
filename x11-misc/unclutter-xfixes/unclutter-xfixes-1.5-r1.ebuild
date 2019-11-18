# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A rewrite of unclutter using the x11-xfixes extension"
HOMEPAGE="https://github.com/Airblader/unclutter-xfixes"
SRC_URI="https://github.com/Airblader/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/libev
	x11-libs/libX11
	x11-libs/libXfixes
	x11-libs/libXi
	!x11-misc/unclutter
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/asciidoc
	virtual/pkgconfig
"

src_compile() {
	emake CC="$(tc-getCC)"
}
