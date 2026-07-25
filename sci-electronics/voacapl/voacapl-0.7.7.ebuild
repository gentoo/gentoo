# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit dot-a fortran-2

DESCRIPTION="HF propagation prediction tool"
HOMEPAGE="https://www.qsl.net/hz1jw/voacapl/index.html"
SRC_URI="https://github.com/jawatson/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="mirror bindist"

src_configure() {
	lto-guarantee-fat
	econf
}

src_compile() {
	# bug 513766
	emake -j1
}

src_install() {
	default
	strip-lto-bytecode
}
