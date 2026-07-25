# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Colorado University binary Decision Diagram library"
HOMEPAGE="https://davidkebo.com/cudd/"
SRC_URI="https://davidkebo.com/source/cudd_versions/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	app-text/doxygen
	dev-texlive/texlive-latex
	media-gfx/graphviz
"

# Minimal change in number repr make extra test fail
# Bug #926371
# Failure are in big number repr
PATCHES=( "${FILESDIR}"/${P}-dropExtraTest.patch )

src_configure() {
	local myconf=(
		--enable-dddmp
		--enable-obj
		--enable-shared
	)
	econf ${myconf[@]}
}

src_install() {
	default

	find "${ED}" -name "*.la" -type f -delete || die
}
