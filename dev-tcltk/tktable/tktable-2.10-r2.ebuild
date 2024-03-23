# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="Tktable${PV}"

DESCRIPTION="full-featured 2D table widget"
HOMEPAGE="http://tktable.sourceforge.net/"
SRC_URI="mirror://sourceforge/tktable/${MY_P}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 ppc x86"
SLOT="0"

DEPEND=">=dev-lang/tk-8.0:="
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

HTML_DOCS=( doc/tkTable.html )
DOCS=( ChangeLog README.txt release.txt )

PATCHES=(
	"${FILESDIR}"/${P}-parallelMake.patch
	"${FILESDIR}"/${P}-clang6.patch
)

src_prepare() {
	default
	sed -e '/^install:/{s: install-doc::}' \
		-e '/^PKG_EXTRA_FILES/{s:=.*:=:}' -i Makefile.in || die
}
