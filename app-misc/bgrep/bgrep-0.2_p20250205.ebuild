# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Grep-like tool to search for binary strings"
HOMEPAGE="https://github.com/tmbinc/bgrep/"
COMMIT="6eb0e4730c5ae88574bdab83b07d7b25ac544778"
SRC_URI="https://github.com/tmbinc/bgrep/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-lang/perl )"

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
	./test/bgrep-test.sh || die
}

src_install() {
	dobin bgrep
	dodoc README
}
