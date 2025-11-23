# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A simple tool to retrieve the X screensaver state"
HOMEPAGE="https://tools.suckless.org/x/xssstate"
SRC_URI="https://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXScrnSaver
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.20130103-gentoo.patch
)

src_prepare() {
	default

	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" PREFIX='/usr' install
	dodoc README xsidle.sh
	doman ${PN}.1
}
