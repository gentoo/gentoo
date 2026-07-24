# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Grep-like tool to search for binary strings"
HOMEPAGE="https://github.com/tmbinc/bgrep/"
SRC_URI="https://github.com/tmbinc/bgrep/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-lang/perl
		dev-util/xxd
	)
"

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
	dodoc README.md
	doman ${PN}.1
}
