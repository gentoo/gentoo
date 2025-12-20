# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

if [[ ${PV} = *9999 ]]; then
	EGIT_REPO_URI="https://github.com/sass/libsass.git"
	inherit git-r3
else
	SRC_URI="https://github.com/sass/libsass/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
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

	# https://bugs.gentoo.org/948969
	# https://github.com/sass/libsass/issues/3193
	filter-flags -fno-semantic-interposition

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	dodoc -r docs

	find "${ED}" -name '*.la' -delete || die
}
