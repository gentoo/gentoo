# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Cal3D is a skeletal based character animation library"
HOMEPAGE="https://mp3butcher.github.io/Cal3D/"
SRC_URI="https://mp3butcher.github.io/Cal3D/sources/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc x86"
IUSE="16bit-indices debug doc"

BDEPEND="
	doc? (
		app-text/doxygen
		app-text/docbook-sgml-utils
	)"

PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-tests.patch
	"${FILESDIR}"/${P}-verbose.patch
	"${FILESDIR}"/${P}-gcc6.patch
	"${FILESDIR}"/${P}-docbook2html.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable 16bit-indices)
}

src_compile() {
	emake

	if use doc; then
		cd docs || die
		emake doc-api
		emake doc-guide
		mkdir -p html/{guide,api} || die
		mv *.{html,gif} html/guide/ || die
		mv api/html/* html/api/ || die
		HTML_DOCS=( docs/html/api docs/html/guide )
	fi
}
