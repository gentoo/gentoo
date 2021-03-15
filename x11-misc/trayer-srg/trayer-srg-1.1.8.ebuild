# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="trayer fork with multi monitor support and cleaned up codebase"
HOMEPAGE="https://github.com/sargon/trayer-srg"
SRC_URI="https://github.com/sargon/${PN}/archive/${P/-srg/}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT GPL-2+"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}"/${PN}-trayer-${PV}

src_configure() {
	# Custom configure script
	./configure --prefix="${EPREFIX}" || die
}

src_compile() {
	emake DEVEL=1 TARGET=${PN} CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	einstalldocs
}
