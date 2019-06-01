# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ncurses-based RPN calculator for the terminal"
HOMEPAGE="https://github.com/drdonahue/repocalc"
SRC_URI="https://github.com/drdonahue/repocalc/archive/v1.0.1.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=sys-libs/ncurses-6.0:0=
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
}
