# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="cross-platform file change monitor with multiple backends"
HOMEPAGE="https://github.com/emcrisostomo/fswatch"
SRC_URI="https://github.com/emcrisostomo/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/13"
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE="doc nls static-libs"

BDEPEND="doc? (
	dev-texlive/texlive-latexrecommended
	app-text/doxygen
)"

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		CXX="$(tc-getCXX)"
}

src_compile() {
	default
	use doc && emake doxygen
}

src_install() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
	use doc && HTML_DOCS=( libfswatch/doc/doxygen/html/* )
	einstalldocs
}
