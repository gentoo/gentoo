# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="\"minimum viable product\" Wayland compositor based on wlroots"
HOMEPAGE="https://gitlab.freedesktop.org/wlroots/wlroots"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/wlroots/wlroots.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/wlroots/wlroots/-/releases/${PV}/downloads/wlroots-${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
	S="${WORKDIR}/wlroots-${PV}"
fi

LICENSE="CC0-1.0"
SLOT="0"
DEPEND="
	dev-libs/wayland
	x11-libs/libxkbcommon
	=gui-libs/wlroots-$(ver_cut 1-2)*:=
"
RDEPEND="
	${DEPEND}
	!gui-libs/wlroots[tinywl(-)]
"
BDEPEND="
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/${P}"-improve-makefile.patch )

src_prepare() {
	default
	sed -i -e "s/-Werror //" tinywl/Makefile || die
}

src_compile() {
	local -x CFLAGS="${CFLAGS} ${CPPFLAGS}"
	tc-export CC PKG_CONFIG
	emake -C tinywl
}

src_install() {
	dodoc tinywl/README.md
	dobin tinywl/tinywl
}
