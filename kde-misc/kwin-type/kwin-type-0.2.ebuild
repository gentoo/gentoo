# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Autotype on KDE's KWin Wayland compositor"
HOMEPAGE="https://git.zx2c4.com/kwin-type/about/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.zx2c4.com/kwin-type/"
else
	SRC_URI="https://git.zx2c4.com/kwin-type/snapshot/kwin-type-${PV}.tar.xz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="GPL-2"
SLOT="0"

BDEPEND="virtual/pkgconfig"
DEPEND="
	>=dev-libs/wayland-1.23
	>=x11-libs/libxkbcommon-1.0
"
RDEPEND="${DEPEND}
	>=kde-plasma/kwin-6.8
"

src_compile() {
	emake CC="$(tc-getCC)" LD="$(tc-getLD)"
}

src_install() {
	dodoc README.md
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		install
}
