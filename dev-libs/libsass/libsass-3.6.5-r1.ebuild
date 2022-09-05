# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

if [[ ${PV} = *9999 ]]; then
	EGIT_REPO_URI="https://github.com/sass/libsass.git"
	inherit git-r3
else
	SRC_URI="https://github.com/sass/libsass/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv x86 ~amd64-linux"
fi

DESCRIPTION="A C/C++ implementation of a Sass CSS compiler"
HOMEPAGE="https://github.com/sass/libsass"
LICENSE="MIT"
SLOT="0/1" # libsass soname

DOCS=( Readme.md SECURITY.md )

src_prepare() {
	default

	if [[ ${PV} != *9999 ]]; then
		[[ -f VERSION ]] || echo "${PV}" > VERSION
	fi

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-shared
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	dodoc -r docs

	find "${ED}" -name '*.la' -delete || die
}
