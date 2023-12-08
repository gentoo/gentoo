# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="ninja-compatible build tool written in C"
HOMEPAGE="https://github.com/michaelforney/samurai"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/michaelforney/samurai.git"
else
	SRC_URI="https://github.com/michaelforney/samurai/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 hppa ppc ppc64 sparc x86"
fi

LICENSE="ISC Apache-2.0 MIT"
SLOT="0"

PATCHES=(
	"${FILESDIR}/${P}-null_pointer_fix.patch" # 786951
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
	dodoc README.md
}
