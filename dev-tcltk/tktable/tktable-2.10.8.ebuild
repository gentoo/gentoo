# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="full-featured 2D table widget"
HOMEPAGE="https://github.com/wjoye/tktable"
SRC_URI="https://github.com/wjoye/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE=""
RESTRICT="test"

DEPEND=">=dev-lang/tk-8.0:="
RDEPEND="${DEPEND}"

HTML_DOCS=( doc/tkTable.html )
DOCS=( ChangeLog README.txt release.txt )

PATCHES=(
	"${FILESDIR}"/${PN}-2.10-parallelMake.patch
	"${FILESDIR}"/${P}-clang6.patch
)

src_prepare() {
	default
	sed -e '/^install:/{s: install-doc::}' \
		-e '/^PKG_EXTRA_FILES/{s:=.*:=:}' -i Makefile.in || die
}
