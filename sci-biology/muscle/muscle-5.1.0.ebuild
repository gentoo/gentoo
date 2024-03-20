# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Multiple sequence comparison by log-expectation"
HOMEPAGE="https://www.drive5.com/muscle/"
SRC_URI="https://github.com/rcedgar/muscle/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${P}/src

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="!sci-libs/libmuscle"

PATCHES=(
	"${FILESDIR}"/0001-Makefile-fix-horribleness-so-that-it-respects-build-.patch
)

src_configure() {
	tc-export CXX
	printf '"%s"\n' "${PV}" > gitver.txt
}

src_install() {
	local OS=$(uname) || die
	dobin ${OS}/muscle
	dodoc *.txt
}
