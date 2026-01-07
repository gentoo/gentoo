# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Small library to access XDG Base Directories Specification paths"
HOMEPAGE="https://github.com/devnev/libxdg-basedir"
SRC_URI="https://github.com/devnev/libxdg-basedir/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86 ~x64-macos"
IUSE="doc"

BDEPEND="doc? ( app-text/doxygen )"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf $(use_enable doc doxygen-html)
}

src_compile() {
	emake

	if use doc; then
		emake doxygen-doc
	fi
}

src_install() {
	use doc && local HTML_DOCS=( doc/html/. )

	default

	find "${ED}" -type f -name '*.la' -delete || die
}
