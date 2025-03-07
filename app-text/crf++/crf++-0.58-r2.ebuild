# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Yet Another CRF toolkit for segmenting/labelling sequential data"
HOMEPAGE="https://taku910.github.io/crfpp/"
SRC_URI="mirror://gentoo/${P^^}.tar.gz"
S="${WORKDIR}/${P^^}"

LICENSE="|| ( BSD LGPL-2.1 )"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="examples"

PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-registers.patch
)
HTML_DOCS=( doc/. )

src_prepare() {
	default
	eautoreconf
}

src_test() {
	local d
	for d in example/*; do
		pushd "${d}" >/dev/null || die
		./exec.sh || die "failed test in ${d}"
		popd >/dev/null || die
	done
}

src_install() {
	default

	if use examples; then
		dodoc -r example
		docompress -x /usr/share/doc/${PF}/example
	fi

	find "${ED}" -name '*.la' -type f -delete || die
}
