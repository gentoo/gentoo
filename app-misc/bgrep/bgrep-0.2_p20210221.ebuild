# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="58c0b83f7ef13cd8d3d7352fadef88a006a514cd"

inherit toolchain-funcs

DESCRIPTION="Grep-like tool to search for binary strings"
HOMEPAGE="https://github.com/tmbinc/bgrep/"
SRC_URI="https://github.com/tmbinc/bgrep/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64"

IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-lang/perl )"

src_prepare() {
	default
	sed -i -e "s|/tmp/|${T}/|g" \
		test/bgrep-test.sh || die
}

src_compile() {
	tc-export CC
	emake
}

src_test() {
	cd test || die
	./bgrep-test.sh || die
}

src_install() {
	dobin bgrep
	dodoc README
}
