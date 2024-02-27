# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="git://c9x.me/qbe.git"
	inherit git-r3
else
	SRC_URI="
		https://c9x.me/compile/release/${P}.tar.xz
		https://c9x.me/git/qbe.git/patch/?id=0d929287d77ccc3fb52ca8bd072678b5ae2c81c8 -> qbe-info-tracking.patch
		https://c9x.me/git/qbe.git/patch/?id=baf11b7175c468d3d9408d332b1c0d529a4957ee -> qbe-parseline-tweaks.patch
		https://c9x.me/git/qbe.git/patch/?id=36946a5142c40b733d25ea5ca469f7949ee03439 -> qbe-dbgfile.patch
	"

	# 64-bit RISC-V only
	KEYWORDS="~amd64 ~arm64 ~riscv"
fi

DESCRIPTION="Pure-C embeddable compiler backend"
HOMEPAGE="https://c9x.me/compile/"

LICENSE="MIT"
SLOT="0"

DOCS=( README doc )

PATCHES=(
	"${DISTDIR}/qbe-info-tracking.patch"
	"${DISTDIR}/qbe-parseline-tweaks.patch"
	"${DISTDIR}/qbe-dbgfile.patch"
)

src_compile() {
	tc-export CC

	emake CFLAGS="-std=c99 ${CPPFLAGS} ${CFLAGS}"
}

src_install() {
	einstalldocs
	emake install DESTDIR="${ED}" PREFIX=/usr
}
