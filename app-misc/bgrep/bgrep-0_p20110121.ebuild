# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/bgrep/bgrep-0_p20110121.ebuild,v 1.1 2011/04/13 14:22:20 flameeyes Exp $

EAPI=4

GITHUB_USER="tmbinc"
GITHUB_HASH="49b098be9548d174023ad05c10f6af9d02b8e18e"
MY_P="${GITHUB_USER}-${PN}-${GITHUB_HASH:0:7}"

inherit toolchain-funcs

DESCRIPTION="grep-like tool to search for binary strings"
HOMEPAGE="https://github.com/tmbinc/bgrep/"
SRC_URI="https://github.com/${GITHUB_USER}/${PN}/tarball/${GITHUB_HASH} -> ${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"
LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64"

IUSE="test"

RDEPEND=""
DEPEND="test? ( dev-lang/perl )"

src_prepare() {
	sed -i -e "s|/tmp/|${T}/|g" \
		test/bgrep-test.sh || die
}

src_compile() {
	tc-export CC
	emake || die
}

src_test() {
	cd test
	./bgrep-test.sh || die
}

src_install() {
	dobin bgrep
	dodoc README
}
