# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GITHUB_USER="tmbinc"
GITHUB_HASH="49b098be9548d174023ad05c10f6af9d02b8e18e"
MY_P="${GITHUB_USER}-${PN}-${GITHUB_HASH:0:7}"

inherit toolchain-funcs

DESCRIPTION="Grep-like tool to search for binary strings"
HOMEPAGE="https://github.com/tmbinc/bgrep/"
SRC_URI="https://github.com/${GITHUB_USER}/${PN}/tarball/${GITHUB_HASH} -> ${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"
LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
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
